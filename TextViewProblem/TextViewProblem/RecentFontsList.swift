//
//  RecentFontsList.swift
//  TextviewEditing
//
//  Created by Bill Bonetti on 10/30/18.
//  Copyright © 2018 Bill Bonetti. All rights reserved.
//

import UIKit

class RecentFontsList {
    
    static private let dataArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("recentfonts.archive")
    }()
    
    static var recentFonts: [String] = {
        do {
            let fontData = try Data(contentsOf: dataArchiveURL)
            let fonts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fontData) as? [String]
            return fonts!
        } catch {
            print("Failed to read recent font archive.")
            return []
        }
    }()
    
    static func updateRecentFonts(newFontName: String) {
        // If the specified font is already in the list, remove it for now.
        var position = 0
        for fontName in recentFonts {
            if fontName == newFontName {
                recentFonts.remove(at: position)
                break
            }
            position += 1
        }
        
        // Insert the specified font at the head of the list
        recentFonts.insert(newFontName, at: 0)
        
        // Remove last entry if there are more than 5 recent fonts.
        if recentFonts.count > 5 {
            recentFonts.remove(at: 5)
        }
        
        print("Saving recent font data to \(dataArchiveURL.path)")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: recentFonts, requiringSecureCoding: true)
            try data.write(to: dataArchiveURL)
        } catch {
            print("Save of recent fonts failed")
        }
    }
    
}
