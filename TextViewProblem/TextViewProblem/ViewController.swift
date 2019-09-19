//
//  ViewController.swift
//  TextViewProblem
//
//  Created by Bill Bonetti on 9/18/19.
//  Copyright © 2019 Bill Bonetti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fontButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FontSelectionPopover" {
            print("segue to popover")
            let fontListViewController = segue.destination as! FontListViewController
            fontListViewController.modalPresentationStyle = .popover
            fontListViewController.preferredContentSize = fontListViewController.view.frame.size
            let popoverPresentationController = fontListViewController.popoverPresentationController!
            popoverPresentationController.sourceRect = fontButton.frame
            
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.permittedArrowDirections = .up

        } else {
            print("Unknown segue")
        }
    }
    
}

