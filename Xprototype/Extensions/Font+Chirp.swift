//
//  Font+Chirp.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI
import UIKit
import CoreText

extension Font {
    private static func loadFontFromBundle(name: String, size: CGFloat) -> Font? {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: "ttf"),
              let fontData = NSData(contentsOf: fontURL),
              let dataProvider = CGDataProvider(data: fontData),
              let cgFont = CGFont(dataProvider) else {
            return nil
        }
        
        // Create CTFont directly from CGFont
        let ctFont = CTFontCreateWithGraphicsFont(cgFont, size, nil, nil)
        let uiFont = ctFont as UIFont
        
        return Font(uiFont)
    }
    
    static func chirpHeavy(size: CGFloat) -> Font {
        if let font = loadFontFromBundle(name: "Chirp-Heavy", size: size) {
            return font
        }
        // Fallback to system font
        return .system(size: size, weight: .heavy)
    }
    
    static func chirpBold(size: CGFloat) -> Font {
        if let font = loadFontFromBundle(name: "Chirp-Bold", size: size) {
            return font
        }
        // Fallback to system font
        return .system(size: size, weight: .bold)
    }
    
    static func chirpRegular(size: CGFloat) -> Font {
        if let font = loadFontFromBundle(name: "Chirp-Regular", size: size) {
            return font
        }
        // Fallback to system font
        return .system(size: size, weight: .regular)
    }
}

