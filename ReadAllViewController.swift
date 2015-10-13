//
//  ReadAllViewController.swift
//  databaseEntry
//
//  Created by Taylor H. Gilbert on 3/30/15.
//  Copyright (c) 2015 Taylor H. Gilbert. All rights reserved.
//

import Foundation
import UIKit

class ReadAllViewController: UIViewController {

    @IBOutlet var textView: UITextView?
    var contentsString: String? = nil
    
    override func viewDidLoad() {
        let cleanedString = contentsString!.componentsSeparatedByString("success\n")
        if cleanedString.count > 1 {
            //self.textView!.text = cleanedString[1]
            let entries = cleanedString[1].componentsSeparatedByString("\n")

            let outputs = entries.map(humanReadable)
            
            let reducedString = outputs.reduce("") {"\($0)\($1)"}
            print(reducedString)
            
            var finalString = ""
            for entry in entries {
            
                
                
                finalString += "\(entry)\n"
            }
            
            self.textView!.text = finalString
        }
    }
    
    func humanReadable(rawString: String) -> String {
        let parts = rawString.componentsSeparatedByString(" ; ")
        //let
        return parts.reduce("", combine: {"\($0)\($1)\n"})
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}