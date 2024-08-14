//
//  HapticsManager.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import UIKit

struct HapticManager {
    enum NotificationFeedbackType {
        case success, info, failure
    }
    
    enum ImpactFeedbackType {
        case light, medium, heavy
    }
    
    // MARK: - Functions
    static func makeNotifiationFeedback(mode: NotificationFeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        
        switch mode {
        case .success:
            generator.notificationOccurred(.success)

        case .failure:
            generator.notificationOccurred(.error)

        default:
            generator.notificationOccurred(.warning)
        }
    }
    
    
    static func makeSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    
    static func makeImpactFeedback(mode: ImpactFeedbackType) {
        var generator: UIImpactFeedbackGenerator
        
        switch mode {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)

        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)

        default:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }

        generator.prepare()
        generator.impactOccurred()
    }
}
