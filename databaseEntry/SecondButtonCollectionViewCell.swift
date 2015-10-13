//
//  SecondButtonCollectionViewCell.swift
//  databaseEntry
//
//  Created by Taylor H. Gilbert on 4/10/15.
//  Copyright (c) 2015 Taylor H. Gilbert. All rights reserved.
//

import UIKit

class SecondButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var button: UIButton?
    
    let nibName = "ButtonCollectionViewCell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        // a comment
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        loadHomeViewFromNib()
    }
    
    func loadHomeViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        view = nib.instantiateWithOwner(self, options:nil)[0] as! UIView
        addSubview(view)
    }

    @IBAction func buttonPressed() {
        print("button pressed")
    }

}
