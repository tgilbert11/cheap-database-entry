//
//  ButtonListCollectionViewItem.swift
//  databaseEntry
//
//  Created by Taylor H. Gilbert on 4/9/15.
//  Copyright (c) 2015 Taylor H. Gilbert. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ButtonListCollectionViewItem: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var homeView: UIView!
    @IBOutlet var humanNameLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var frequencyLabel: UILabel?
    @IBOutlet var modifierCollectionView: UICollectionView?
    @IBOutlet var labelCell: UICollectionViewCell?
    
    var viewController: ViewController?
    let nibName = "ButtonListCollectionViewItem"
    var databaseItemType: DatabaseItemType? {
        didSet {
            self.updateUI()
        }
    }
    var currentModifierDepth = -1
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("cell init from Coder")
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("cell init with Frame")
        setup()
    }
    
    func setup() {
        loadHomeViewFromNib()
        addSubview(homeView)
        print("hello from cell!")
        self.humanNameLabel!.text = "new name label"
        self.modifierCollectionView!.backgroundColor = UIColor.whiteColor()
        self.modifierCollectionView!.registerClass(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "labelCell")
        self.modifierCollectionView!.registerClass(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: "buttonCell")
        self.modifierCollectionView!.registerClass(SecondButtonCollectionViewCell.self, forCellWithReuseIdentifier: "secondButtonCell")
        self.modifierCollectionView!.hidden = true
    }
    
    func loadHomeViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        homeView = nib.instantiateWithOwner(self, options:nil)[0] as! UIView
        //view.frame = bounds
        //view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(homeView)
    }
    
    func replaceDatabaseItemType(databaseItemType: DatabaseItemType) {
        self.databaseItemType = databaseItemType
        updateUI()
    }
    
    func updateUI() {
        print("updateUI")
        
        self.humanNameLabel!.text = self.databaseItemType!.humanName
        
        if self.databaseItemType!.showsSummary {
            self.timeLabel!.hidden = false
            self.frequencyLabel!.hidden = false
        }
        else {
            self.timeLabel!.hidden = true
            self.frequencyLabel!.hidden = true
        }
    }
       
    func rowSelected() {
        print("rowSelected")
        
        if currentModifierDepth < self.databaseItemType!.possibleModifierLists.count - 1 {
            print("entered modifier page")
            currentModifierDepth++
            self.modifierCollectionView!.reloadData()
            self.modifierCollectionView!.hidden = false
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell? = nil
        if currentModifierDepth >= 0 {
            if indexPath.row == 0 {
                cell = self.modifierCollectionView!.dequeueReusableCellWithReuseIdentifier("labelCell", forIndexPath: indexPath) as! LabelCollectionViewCell
                (cell as! LabelCollectionViewCell).label!.text = self.databaseItemType!.possibleModifierLists[currentModifierDepth].listName
            }
            else {
                cell = self.modifierCollectionView!.dequeueReusableCellWithReuseIdentifier("secondButtonCell", forIndexPath: indexPath) as! SecondButtonCollectionViewCell
                (cell as! SecondButtonCollectionViewCell).button!.setTitle(self.databaseItemType!.possibleModifierLists[currentModifierDepth].items[indexPath.row-1].humanName, forState: UIControlState.Normal)
            }
        }
        else {
            cell = self.modifierCollectionView!.dequeueReusableCellWithReuseIdentifier("labelCell", forIndexPath: indexPath) as! LabelCollectionViewCell
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var modifierAdder = 0
        if currentModifierDepth >= 0 {
            modifierAdder += self.databaseItemType!.possibleModifierLists[currentModifierDepth].items.count
        }
        return 1 + modifierAdder
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}





