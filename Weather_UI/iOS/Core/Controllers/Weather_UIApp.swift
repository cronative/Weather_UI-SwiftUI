//
//  Weather_UIApp.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import SwiftUI

@main
struct Weather_UIApp: App {
    
    // MARK: - Variables
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    // MARK: - Views
    var body: some Scene {
        WindowGroup {
            MainView(mainViewModel: MainViewModel(forTest: true))
//            CurrentWeatherInfoScrollView(mainViewModel: MainViewModel(forTest: true))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        print("File Manager", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        return true
    }
}


