//
//  FontListViewController.swift
//  TextviewEditing
//
//  Created by Bill Bonetti on 10/7/18.
//  Copyright © 2018 Bill Bonetti. All rights reserved.
//

import UIKit

class FontListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedFontFamilies: [String] = []
    
    public var currentFontName: String?
    weak var fontDelegate: FontListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fontArray: [String] = []
        
        for familyName in UIFont.familyNames {
            fontArray.append(familyName)
        }
        
        sortedFontFamilies = fontArray.sorted()
    }
    
    // MARK: - TableView functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RecentFontsList.recentFonts.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if RecentFontsList.recentFonts.count > 0 {
            if section == 0 {
                return "RECENT"
            } else {
                return "ALL FONTS"
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RecentFontsList.recentFonts.count > 0 && section == 0 {
            return RecentFontsList.recentFonts.count
        } else {
            return sortedFontFamilies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FontNameCell
        
        // configure the cell
        var fontName: String
        if indexPath.section == 0 && RecentFontsList.recentFonts.count > 0 {
            fontName = RecentFontsList.recentFonts[indexPath.row]
        } else {
            fontName = sortedFontFamilies[indexPath.row]
        }
        
        let fontSize = cell.textLabel?.font.pointSize
        let font = UIFont(name: fontName, size: fontSize!)
        
        let attrs = [NSAttributedString.Key.font: font!] as [NSAttributedString.Key : Any]
        cell.fontNameLabel?.attributedText = NSAttributedString(string: fontName, attributes: attrs)
        
        if fontName == currentFontName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
            if indexPath.section == 0 && RecentFontsList.recentFonts.count > 0 {
                currentFontName = RecentFontsList.recentFonts[indexPath.row]
            } else {
                currentFontName = sortedFontFamilies[indexPath.row]
            }
            
            fontDelegate?.onFontChange(fontName: currentFontName!)
            RecentFontsList.updateRecentFonts(newFontName: currentFontName!)
            dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        if let headerLabel = header.textLabel {
            headerLabel.textColor = UIColor.gray //UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            headerLabel.font = UIFont.systemFont(ofSize: 15)
        }
        
        view.tintColor = UIColor.white //UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0);
    }
    
    
}

protocol FontListViewControllerDelegate: AnyObject {
    func onFontChange(fontName: String)
    
}
