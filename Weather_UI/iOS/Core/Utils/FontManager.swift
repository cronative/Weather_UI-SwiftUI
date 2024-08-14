//
//  FontManager.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import SwiftUI

enum Montserrat {
    case regular
    case medium
    case semibold
    case bold
    
    func font(size: CGFloat) -> Font {
        switch self {
        case .regular:
            return .custom("Montserrat-Regular", size: size)
        case .medium:
            return .custom("Montserrat-Medium", size: size)
        case .semibold:
            return .custom("Montserrat-SemiBold", size: size)
        case .bold:
            return .custom("Montserrat-Bold", size: size)
            
        }
    }
    
    // MARK: - Functions
    func getUIFont(size: CGFloat) -> UIFont {
        switch self {
        case .regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
        case .medium:
            return UIFont(name: "Montserrat-Medium", size: size)!
        case .semibold:
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        case .bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
        }
    }
}


enum Avenir {
    case light
    case regular
    case bold
    case black
    
    func font(size: CGFloat) -> Font {
        switch self {
        case .light:
            return .custom("Avenir-Light", size: size)
        case .regular:
            return .custom("Avenir-Regular", size: size)
        case .bold:
            return .custom("Avenir-Heavy", size: size)
        case .black:
            return .custom("Avenir-Black", size: size)
            
        }
    }
}


enum Nocturne {
    case light
    case regular
    case regularItalic
    case medium
    case semibold
    case semiboldItalic
    case bold
    
    case extraBold
    
    
    // MARK: - Functions
    func font(size: CGFloat) -> Font {
        switch self {
        case .light:
            return .custom("NocturneSerif-Light", size: size)

        case .regular:
            return .custom("NocturneSerif-Regular", size: size)

        case .regularItalic:
            return .custom("NocturneSerif-Regularitalic", size: size)

        case .medium:
            return .custom("NocturneSerif-Medium", size: size)
            
        case .semibold:
            return .custom("NocturneSerif-SemiBold", size: size)
            
        case .semiboldItalic:
            return .custom("NocturneSerif-SemiBolditalic", size: size)
            
        case .bold:
            return .custom("NocturneSerif-Bold", size: size)
            
        case .extraBold:
            return .custom("NocturneSerifTest-ExtraBold", size: size)
        }
    }
}


