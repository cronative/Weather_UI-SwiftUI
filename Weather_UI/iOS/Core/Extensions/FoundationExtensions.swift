//
//  FoundationExtensions.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import UIKit

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
    
    var hasNotch: Bool {
        guard let window = getKeyWindow() else { return false }
        return window.safeAreaInsets.bottom > 0
    }
    
    func getKeyWindow() -> UIWindow? {
        // UIApplication.shared.keyWindow is deprecated From iOS 13.0
        // and as such we'll use filter and CompactMap to fetch the KeyWindow
        return UIApplication.shared.connectedScenes
        // better to have a filter so that it doesn't process background,unttached state
            .filter({$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .first(where: { $0.isKeyWindow })
    }
    
}

extension Int {
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func degreeToRadians() -> CGFloat {
        return  (CGFloat(self) * .pi) / 180
    }
    
    func toPhoneNumber() -> String {
        let stringNumber = String(self)
        return stringNumber.prefix(5) +  "-" + stringNumber.suffix(5)
    }
}

extension CGFloat {
    func clean(places: Int) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.\(places)f", self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
}

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
    
    func clean(places: Int) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.\(places)f", self)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
