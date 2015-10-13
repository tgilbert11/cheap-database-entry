
//
//  ViewController.swift
//  databaseEntry
//
//  Created by Taylor H. Gilbert on 3/25/15.
//  Copyright (c) 2015 Taylor H. Gilbert. All rights reserved.
//

import UIKit
import Foundation

struct DatabaseItemType {
    var humanName: String
    var internalShorthand: String
    var showsSummary: Bool
    var possibleModifierLists: [(listName: String, items: [(humanName: String, internalShorthand: String)])]
}

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var locationSegmentedControl: UISegmentedControl?
    @IBOutlet var prodDevSegmentedControl: UISegmentedControl?
    @IBOutlet var usernameTextField: UITextField?
    @IBOutlet var weightTextField: UITextField?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var checkmarkImageView: UIImageView?
    @IBOutlet var xImageView: UIImageView?
    
    var readyForInput = true
    @IBOutlet var buttonMaskView: UIView?
    
    var lastRequestWasForReadAll = false
    var lastRequestResponseString = ""
    
    var databaseItemTypes: [DatabaseItemType] = []
    @IBOutlet var buttonCollectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testStruct()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testStruct() {
        self.databaseItemTypes.append(DatabaseItemType(humanName: "first alarm", internalShorthand: "firstAlarm", showsSummary: true, possibleModifierLists: []))
        self.databaseItemTypes.append(DatabaseItemType(humanName: "got out of bed", internalShorthand: "gotOutOfBed", showsSummary: true, possibleModifierLists: [(listName: "reason", [("had to", "h"), ("wanted to", "w")]) ]))
        self.databaseItemTypes.append(DatabaseItemType(humanName: "did some exercise", internalShorthand: "didSomeExercise", showsSummary: true, possibleModifierLists: [(listName: "intensity", [("light", "l"), ("moderate", "m"), ("strenuous", "s")]), (listName: "type", [("strength", "t"), ("cardio", "c")]) ]))
        
        self.databaseItemTypes.append(DatabaseItemType(humanName: "felt great", internalShorthand: "feltGreat", showsSummary: false, possibleModifierLists: []))
        self.databaseItemTypes.append(DatabaseItemType(humanName: "felt like crap", internalShorthand: "feltLikeCrap", showsSummary: false, possibleModifierLists: []))
        
        
        for databaseItemType in databaseItemTypes {
            print("human name: \(databaseItemType.humanName), internalShorthand: \(databaseItemType.internalShorthand)")
            for modifierList in databaseItemType.possibleModifierLists {
                print("        list name: \(modifierList.listName)")
                for modifierPair in modifierList.items {
                    print("                modifier name: \(modifierPair.humanName), shorthand: \(modifierPair.internalShorthand)")
                }
            }
            print("")
        }
        
    }

    @IBAction func leftForWork() { postEntry(named: "&category=drivingTime&tripType=leftForWork&route=notSureYet", withModifiers: "") }
    @IBAction func gotToWork1785() { postEntry(named: "&category=drivingTime&tripType=arrivedAtWork&route=h17h85", withModifiers: "") }
    @IBAction func gotToWork179() { postEntry(named: "&category=drivingTime&tripType=arrivedAtWork&route=h17h9", withModifiers: "") }
    @IBAction func gotToWorkOSCH85() { postEntry(named: "&category=drivingTime&tripType=arrivedAtWork&route=OSCHh85", withModifiers: "") }
    @IBAction func gotToWorkOSCH9() { postEntry(named: "&category=drivingTime&tripType=arrivedAtWork&route=OSCHh9", withModifiers: "") }
    @IBAction func leftWork() { postEntry(named: "&category=drivingTime&tripType=leftForHome&route=notSureYet", withModifiers: "") }
    @IBAction func gotHome1785() { postEntry(named: "&category=drivingTime&tripType=arrivedAtHome&route=h17h85", withModifiers: "") }
    @IBAction func gotHome179() { postEntry(named: "&category=drivingTime&tripType=arrivedAtHome&route=h17h9", withModifiers: "") }
    @IBAction func gotHomeOSCH85() { postEntry(named: "&category=drivingTime&tripType=arrivedAtHome&route=OSCHh85", withModifiers: "") }
    @IBAction func gotHomeOSCH9() { postEntry(named: "&category=drivingTime&tripType=arrivedAtHome&route=OSCHh9", withModifiers: "") }

    @IBAction func ateLunch() { postEntry(named: "&category=meals&mealType=lunch&heaviness=moderate", withModifiers: "") }
    @IBAction func ateDinner() { postEntry(named: "&category=meals&mealType=dinner&heaviness=moderate", withModifiers: "") }
    @IBAction func ateLunchLight() { postEntry(named: "&category=meals&mealType=lunch&heaviness=light", withModifiers: "") }
    @IBAction func ateDinnerLight() { postEntry(named: "&category=meals&mealType=dinner&heaviness=light", withModifiers: "") }
    @IBAction func ateLunchHeavy() { postEntry(named: "&category=meals&mealType=lunch&heaviness=heavy", withModifiers: "") }
    @IBAction func ateDinnerHeavy() { postEntry(named: "&category=meals&mealType=dinner&heaviness=heavy", withModifiers: "") }

    @IBAction func hadADrink() { postEntry(named: "&category=drinks&drinkType=alcohol", withModifiers: "") }
    @IBAction func hadCoffee() { postEntry(named: "&category=drinks&drinkType=coffee", withModifiers: "") }
    @IBAction func hadWater() { postEntry(named: "&category=drinks&drinkType=water", withModifiers: "") }

    @IBAction func didSomeExercise() { postEntry(named: "&category=exercise&type=cardio&intensity=5&duration=20", withModifiers: "") }

    @IBAction func weight() {
        if self.weightTextField!.text! != "" {
            postEntry(named: "&category=weight&timeOfDay=morning&weight=", withModifiers: self.weightTextField!.text!)
            self.weightTextField!.text! = ""
            self.weightTextField!.resignFirstResponder()
        }
    }
    
    @IBAction func firstAlarm() { postEntry(named: "&category=sleep&event=alarmWentOff&feeling=average", withModifiers: "") }
    @IBAction func gotOutOfBed() { postEntry(named: "&category=sleep&event=wokeUp&feeling=average", withModifiers: "") }
    @IBAction func wentToBed() { postEntry(named: "&category=sleep&event=wentToBed&feeling=average", withModifiers: "") }
    @IBAction func firstAlarmTired() { postEntry(named: "&category=sleep&event=alarmWentOff&feeling=tired", withModifiers: "") }
    @IBAction func gotOutOfBedTired() { postEntry(named: "&category=sleep&event=wokeUp&feeling=tired", withModifiers: "") }
    @IBAction func wentToBedTired() { postEntry(named: "&category=sleep&event=wentToBed&feeling=tired", withModifiers: "") }
    @IBAction func firstAlarmExhausted() { postEntry(named: "&category=sleep&event=alarmWentOff&feeling=exhausted", withModifiers: "") }
    @IBAction func gotOutOfBedExhausted() { postEntry(named: "&category=sleep&event=wokeUp&feeling=exhausted", withModifiers: "") }
    @IBAction func wentToBedExhausted() { postEntry(named: "&category=sleep&event=wentToBed&feeling=exhausted", withModifiers: "") }
    @IBAction func firstAlarmHungover() { postEntry(named: "&category=sleep&event=alarmWentOff&feeling=hungover", withModifiers: "") }
    @IBAction func gotOutOfBedHungover() { postEntry(named: "&category=sleep&event=wokeUp&feeling=hungover", withModifiers: "") }
    @IBAction func wentToBedHungover() { postEntry(named: "&category=sleep&event=wentToBed&feeling=hungover", withModifiers: "") }

    @IBAction func bio() { postEntry(named: "&category=bio&type=pooped", withModifiers: "") }
    
    func postEntry(named name: String, withModifiers mods: String) {
        if readyForInput {
            readyForInput = false
            lastRequestWasForReadAll = false
            buttonMaskView!.hidden = false
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd-hh-mm-ss"
            print(dateFormatter.stringFromDate(date))
            
            let tail = "time=%22\(dateFormatter.stringFromDate(date))%22\(name)\(mods)"
            let response: () = requestURL(tail)
            
            //print(response!)
        }
    }
    
    @IBAction func readAll() {
        if readyForInput {
            readyForInput = false
            lastRequestWasForReadAll = true
            buttonMaskView!.hidden = false
            let response: () = requestURL("readAll")
            //print(response!)
        }
    }

    func requestURL(tail: String){
        requestStarted()
        
        var hostname = "192.168.1.110"
        if locationSegmentedControl!.selectedSegmentIndex == 1 {
            hostname = "taylorg.no-ip.org"
        }
        
        var prodDev = "prod"
        if prodDevSegmentedControl!.selectedSegmentIndex == 1 {
            prodDev = "dev"
        }
        
        let username = usernameTextField!.text
        
        let requestAddress = "http://\(hostname)/cgi-bin/database/add?username=\(username!)&\(tail)"
        
        print(requestAddress)
        
        let url = NSURL(string: requestAddress)!
        let urlRequest = NSURLRequest(URL: url, cachePolicy:NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 7)
        //var urlResponse: NSURLResponse? = nil
        //var error: NSError? = nil
        //let data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &urlResponse, error: &error)
        let operationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: operationQueue, completionHandler: {response, data, error in
                print("completed")
                if data != nil {
                    print(" successfully")
                    let response = NSString(data: data!, encoding: NSUTF8StringEncoding) as String?
                    if response != nil {
                    //print("response: \(response!)")
                        let responseLines = response!.componentsSeparatedByString("\n")
                        if responseLines.count > 0 {
                            if responseLines[0] == "command recognized" {
                                //print(response!)
                                self.requestCompletedSuccessfully()
                                if self.lastRequestWasForReadAll {
                                    self.lastRequestResponseString = response!
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.performSegueWithIdentifier("showReadAll", sender: self)
                                    })
                                }
                            }
                            else {
                                self.requestFailed()
                            }
                        }
                        else {
                            self.requestFailed()
                        }
                    }
                    else {
                        self.requestFailed()
                    }
                    
                }
                else {
                    print(" without data")
                    self.requestFailed()
                }
            })
        
//        
//        var response: String? = nil
//        if data != nil {
//            response = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        }
//        else {
//            print("dataIsNil")
//        }
//        
//        if response != nil {
//            let responseLines = response!.componentsSeparatedByString("\n")
//            if responseLines.count > 0 {
//                if responseLines[0] == "success" {
//                    print(response!)
//                    requestCompletedSuccessfully()
//                }
//                else {
//                    requestFailed()
//                }
//            }
//            else {
//                requestFailed()
//            }
//        }
//        else {
//            requestFailed()
//        }
    }
    
    func requestStarted() {
        print("requestStarted")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            print("started async background")
            dispatch_async(dispatch_get_main_queue(), {
                print("started async main")
                self.activityIndicator!.startAnimating()
                self.checkmarkImageView!.hidden = true
                self.xImageView!.hidden = true
            })
        })
    }
    
    func requestCompletedSuccessfully() {
        print("requestCompletedSucessfully")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            print("successful async background")
            dispatch_async(dispatch_get_main_queue(), {
                print("successful async main")
                self.activityIndicator!.stopAnimating()
                self.checkmarkImageView!.hidden = false
                let delay = Int64(1 * Double(NSEC_PER_SEC))
                let time = dispatch_time(DISPATCH_TIME_NOW, delay)
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.clearIndicator()
                })
            })
        })
    }
    
    func requestFailed() {
        print("requestFailed")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            print("failed async background")
            dispatch_async(dispatch_get_main_queue(), {
                print("failed async main")
                self.activityIndicator!.stopAnimating()
                self.xImageView!.hidden = false
                let delay = Int64(1 * Double(NSEC_PER_SEC))
                let time = dispatch_time(DISPATCH_TIME_NOW, delay)
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.clearIndicator()
                })
            })
        })
    }
    
    func clearIndicator() {
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.checkmarkImageView!.alpha = 0
            self.xImageView!.alpha = 0
            self.buttonMaskView!.alpha = 0
            print("animation started")
        }, completion: { finished in
            self.checkmarkImageView!.hidden = true
            self.checkmarkImageView!.alpha = 1
            self.xImageView!.hidden = true
            self.xImageView!.alpha = 1
            self.readyForInput = true
            self.buttonMaskView!.hidden = true
            self.buttonMaskView!.alpha = 1
            print("animation complete")
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField!.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "showReadAll" {
            let destinationViewController = segue.destinationViewController as! ReadAllViewController
            destinationViewController.contentsString = lastRequestResponseString
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ButtonListCollectionViewItem", forIndexPath: indexPath) as! ButtonListCollectionViewItem
        //print(cell)
        cell.databaseItemType = self.databaseItemTypes[indexPath.row]
        cell.viewController = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.databaseItemTypes.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ButtonListCollectionViewItem
        
        cell.rowSelected()
        
        //postEntry(named: cell.databaseItemType!.internalShorthand, withModifiers: "")
    }
}

