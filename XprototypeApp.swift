//
//  XprototypeApp.swift
//  Xprototype
//
//  Created by Nicolas Duc-Dodon on 11/22/25.
//

import SwiftUI

@main
struct XprototypeApp: App {
    init() {
        #if DEBUG
        // Print available Chirp fonts to find correct names
        FontHelper.printAvailableFonts()
        
        // Test font availability
        print("\n=== Font Availability Check ===")
        print("Chirp-Heavy: \(FontHelper.isFontAvailable("Chirp-Heavy"))")
        print("Chirp-Bold: \(FontHelper.isFontAvailable("Chirp-Bold"))")
        print("Chirp-Regular: \(FontHelper.isFontAvailable("Chirp-Regular"))")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// A SwiftUI preview.
#Preview {
    MainTabView()
}
