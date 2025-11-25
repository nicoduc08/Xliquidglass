//
//  FontHelper.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import UIKit
import CoreText
import CoreGraphics

struct FontHelper {
    /// Print all available font family names and their font names
    static func printAvailableFonts() {
        print("\n=== Available Font Families ===")
        for family in UIFont.familyNames.sorted() {
            if family.lowercased().contains("chirp") {
                print("\nFamily: \(family)")
                for fontName in UIFont.fontNames(forFamilyName: family).sorted() {
                    print("  - \(fontName)")
                }
            }
        }
        
        // Also check all fonts for "Chirp" in the name
        print("\n=== All Fonts Containing 'Chirp' ===")
        let allFontNames = UIFont.familyNames.flatMap { UIFont.fontNames(forFamilyName: $0) }
        for fontName in allFontNames.filter({ $0.lowercased().contains("chirp") }).sorted() {
            print("  - \(fontName)")
        }
        
        // Check bundle for font files
        print("\n=== Checking Bundle for Font Files ===")
        if let fontURLs = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) {
            print("Found \(fontURLs.count) .ttf files in bundle:")
            for url in fontURLs {
                print("  - \(url.lastPathComponent)")
            }
        } else {
            print("No .ttf files found in bundle!")
        }
        
        // Extract actual PostScript names from font files
        print("\n=== Extracting Font PostScript Names ===")
        let fontNames = ["Chirp-Heavy", "Chirp-Bold", "Chirp-Regular"]
        var fontMapping: [String: String] = [:]
        
        for fontName in fontNames {
            if let fontPath = Bundle.main.path(forResource: fontName, ofType: "ttf"),
               let fontData = NSData(contentsOfFile: fontPath),
               let dataProvider = CGDataProvider(data: fontData),
               let font = CGFont(dataProvider),
               let postScriptName = font.postScriptName as String? {
                print("\(fontName).ttf -> PostScript name: \(postScriptName)")
                fontMapping[fontName] = postScriptName
                
                // Try to create UIFont with the PostScript name
                if let uiFont = UIFont(name: postScriptName, size: 17) {
                    print("  ✓ Font '\(postScriptName)' is available!")
                } else {
                    print("  ✗ Font '\(postScriptName)' is NOT available")
                }
            }
        }
        
        print("\n=== Recommended Font Names to Use ===")
        for (fileName, postScriptName) in fontMapping.sorted(by: { $0.key < $1.key }) {
            print("Use: .font(.custom(\"\(postScriptName)\", size: 15))")
        }
    }
    
    /// Check if a specific font name is available
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 17) != nil
    }
}

