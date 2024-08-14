//
//  NetworkManager.swift
//  Weather_UI
//
//  Created by Nikunj on 11/05/24.
//

import Foundation
import Alamofire

protocol APIRequestProtocol {
    func makeRequest<T: Decodable>(request: URLRequest) async throws -> T
}


enum APIs: URLRequestConvertible, APIRequestProtocol {
    
    case getCities(city: String)
    
    static let cityURL: URL = URL(string: "https://wft-geo-db.p.rapidapi.com/v1")!

    static let reachability = NetworkReachabilityManager()!
    
    static var timestamp: Int64 = 0
    
    static let rapidApiKey = "14ff73caa5msh0f564971b93e7f9p170b30jsn3c532fbc86cb"
    
    
    // specifying the endpoints for each API
    var path: String {
        switch self {
        case .getCities(_):
            return "/geo/cities"
        }
    }
    
    
    // specifying the methods for each API
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
//    // If the API requires body or queryString encoding, it can be specified here
//    var encoding : URLEncoding {
//        switch self {
//        case .get:
//            return .queryString
//            
//        default:
//            return .default
//        }
//    }
    
    static func addHeaders(request: inout URLRequest, needsEncryption: Bool = false) {
        /// add headers
        
    }
    
    /// `UTILITY` functions
    func checkIfValidRequest() async -> Bool {
        guard Self.reachability.isReachable else {
            return false
        }
        return true
    }
    
    /// `create` and return the request for the API call, for `POST`, the queries are appended to the body
    func asURLRequest() throws -> URLRequest {
        var requestString = ""
        var request: URLRequest!
        
        switch self {
       
        case .getCities(let city):
            requestString = "?namePrefix=\(city)"
            request = URLRequest(url: Self.cityURL.appendingPathComponent(path + requestString))
            request.httpMethod = method.rawValue
            request.removePercentEncoding(request: &request)
            request.addValue("wft-geo-db.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
            request.addValue(Self.rapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        }
        

        //print("THE URL Request", request.url!)
        
        return request
    }
    
    // MARK: - functions for calling the API's
    /// `GET`
    func makeRequest<T: Decodable>(request: URLRequest) async throws -> T {
        guard await checkIfValidRequest() else { throw APIErrorResponse.networkError }
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let (data, _) = try await session.data(for: request)
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch {
            throw APIErrorResponse.decodingError
        }
    }
    
    /// `Cancels` API Requests
    static func cancelAPIRequests() {
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach({$0.cancel()})
        }
    }
    
    static func getUserNetworkStatus() -> Bool {
        return reachability.isReachable
    }
}

protocol NetworkRequestProtocol {

    // MARK: - Functions
    func getCitiesForPrefix(cityName: String) async throws -> CityData?
    
    func isNetworkReachable() -> Bool
    func cancelAPIRequests()
}

struct NetworkManager: NetworkRequestProtocol {
    
    // MARK: - Variables
    var requestManager: APIRequestProtocol
    let networkReachability = NetworkReachabilityManager()!
    
    // MARK: - Init
    init(requestManager: APIRequestProtocol = APIs.getCities(city: "")) {
        self.requestManager = requestManager
    }
    
    // MARK: - Functions
    private func getCitiesForPrefix(cityName: String, onCompletion: @escaping(CityData?, APIErrorResponse?) -> Void){
        Alamofire.request(APIs.getCities(city: cityName)).responseJSON { (json) in
            if let payload = json.result.value as? [String: Any] {
                let jsonDecoder = JSONDecoder()
                do {
                    let jsonData = try! JSONSerialization.data(withJSONObject: payload, options: .sortedKeys)
                    let citiesData = try jsonDecoder.decode(CityData.self, from: jsonData)
                    onCompletion(citiesData, nil)
                } catch {
                    //print( error)
                    onCompletion(nil, APIErrorResponse.decodingError)
                }
            } else {
                onCompletion(nil, APIErrorResponse.networkError)
            }
        }
    }
    
    func getCitiesForPrefix(cityName: String) async throws -> CityData? {
        try await withCheckedThrowingContinuation { continuation in
            getCitiesForPrefix(cityName: cityName) { (response, error) in
                guard error == nil else {
                    continuation.resume(throwing: error ?? APIErrorResponse.errorResponse)
                    return
                }
                continuation.resume(with: .success(response))
            }
        }
    }
    
    func isNetworkReachable() -> Bool {
        return APIs.getUserNetworkStatus()
    }
    
    func cancelAPIRequests() {
        return APIs.cancelAPIRequests()
    }
}



extension URLRequest {
    func removePercentEncoding(request: inout URLRequest){
        request = URLRequest(url: URL(string: (self.url!.absoluteString.replacingOccurrences(of: "%3F", with: "?")))!)
    }
}
