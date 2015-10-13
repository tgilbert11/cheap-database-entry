//
//  LabelCollectionViewCell.swift
//  databaseEntry
//
//  Created by Taylor H. Gilbert on 4/10/15.
//  Copyright (c) 2015 Taylor H. Gilbert. All rights reserved.
//

import Foundation
import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet var label: UILabel?
    
    let nibName = "LabelCollectionViewCell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
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

}