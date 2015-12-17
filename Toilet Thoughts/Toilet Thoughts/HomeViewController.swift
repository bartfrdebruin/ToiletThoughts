//
//  HomeViewController.swift
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 17-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

import UIKit


@objc class HomeViewController: UIViewController {
    
    var internetReachability: Reachability
    var homeVC: UIViewController
    var weekOfYear: NSInteger
    var weekAndYear: NSInteger
    var week: NSInteger
    var year: NSInteger
    
    @IBOutlet var highestScoringToiletThought: UILabel!
    @IBOutlet var highestScoringUser: UILabel!
    @IBOutlet var highestScoreNumberLabel: UILabel!
    @IBOutlet var thumbsUp: UIImageView!
    @IBOutlet var thumbsDown: UIImageView!
    
    var highestScoreObject: PFObject
    
    
    @IBAction func browseThoughts(sender: AnyObject) {
        
        let listThoughtTableVC: ListThoughtTableVC = ListThoughtTableVC(nibName: "listThoughtTableVC", bundle: nil)
        
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.80)
        UIView.setAnimationCurve(.EaseInOut)
        UIView.setAnimationTransition(.FlipFromRight, forView: (self.navigationController?.view)!, cache: false)
        
        self.navigationController!.pushViewController(listThoughtTableVC, animated: true)
        UIView.commitAnimations()
        self.navigationController!.navigationBarHidden = false
        listThoughtTableVC.retrieveFromParseScore()
    }
    
    
    @IBAction func addThoughts(sender: AnyObject) {
        
        let addThoughtVC: AddThoughtVC = AddThoughtVC(nibName: "AddThoughtVC", bundle: nil)
        
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.80)
        UIView.setAnimationCurve(.EaseInOut)
        UIView.setAnimationTransition(.FlipFromLeft, forView: (self.navigationController?.view)!, cache: false)
        
        self.navigationController!.pushViewController(addThoughtVC, animated: true)
        UIView.commitAnimations()
        self.navigationController!.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        
        let date: NSDate = NSDate()
        let calender: NSCalendar = NSCalendar.currentCalendar()
        
        self.weekOfYear = calender.components(.WeekOfYear, fromDate:date).weekOfYear
        self.year = calender.components(.Year, fromDate: date).year * 100
        self.weekAndYear = (self.weekOfYear + self.year)
        
        if (self.weekOfYear == 1) {
            
            let query = PFQuery(className: "ToiletThought")
            query.whereKey("weekNumber", equalTo: self.weekOfYear - 49)
            query.orderByDescending("score")
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?)  -> Void in
                
                if (objects != nil) {
                    
                    self.highestScoreObject = objects![0]
                    self.highestScoringToiletThought.text = self.highestScoreObject["toiletThought"]as? String
                    self.highestScoringUser.text = self.highestScoreObject["userName"]as? String
                    
                    let newInt = (self.highestScoreObject ["score"]as? Int)
                    let highestScoreNumber = NSNumber.init(integer: newInt!)
                    self.highestScoreNumberLabel.text = "\(highestScoreNumber)"
                }
            }
        }
        
        let query = PFQuery(className: "ToiletThought")
        query.whereKey("weekNumber", equalTo: self.weekOfYear - 1)
        query.orderByDescending("score")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?)  -> Void in
            
            if (objects != nil) {
                
                self.highestScoreObject = objects![0]
                self.highestScoringToiletThought.text = self.highestScoreObject["toiletThought"]as? String
                self.highestScoringUser.text = self.highestScoreObject["userName"]as? String
                
                let newInt = (self.highestScoreObject ["score"]as? Int)
                let highestScoreNumber = NSNumber.init(integer:newInt!)
                let scoreIntValue: Int = newInt!
                if scoreIntValue >= 0 {
                    self.thumbsDown.hidden = true
                    self.thumbsUp.hidden = false
                    self.highestScoreNumberLabel.text = "\(highestScoreNumber)"
                    
                    // Here we write the animation for the homeScreen Thought
                    let string = "self.highestScoringToiletThought!"
                    let dict: NSMutableDictionary
                    dict["string"] = string
                    dict["currentCount"] = 0
                    let timer = NSTimer.init(timeInterval: 0.1, target: self, selector: "typingLabel", userInfo: dict, repeats: true)
                    timer.fire()
                    
                } else if scoreIntValue < 0 {
                    
                    self.thumbsDown.hidden = false
                    self.thumbsUp.hidden = true
                    self.highestScoreNumberLabel.text = "\(highestScoreNumber)"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        self.internetReachability = (Reachability .reachabilityForInternetConnection())
        self.internetReachability .startNotifier()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged", name: kReachabilityChangedNotification, object: nil)
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let currentReachability: Reachability = note.object as! Reachability
        self.updateInterfaceWithReachability(currentReachability)
    }
    
    func updateInterfaceWithReachability(reachability:Reachability) {
        
        let netStatus: NetworkStatus = reachability.currentReachabilityStatus()
        if netStatus == NotReachable {
            
            self.thumbsDown.hidden = true
            self.thumbsUp.hidden = true
            let noInternetViewController = NoInternetViewController()
            self.presentViewController(noInternetViewController, animated: true, completion:nil)
        } else {
            
           self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func typingLabel(theTimer:NSTimer) {
        
        let userInfoDict: NSMutableDictionary = theTimer.userInfo as! NSMutableDictionary
        var theString: String = (theTimer.userInfo!["string"] as! String)
        var currentCount: Int = (theTimer.userInfo!["currentCount"]as! Int)
        currentCount++
        
        userInfoDict ["currentCount"] = currentCount
        
//        (theString.substringToIndex(currentCount))
//        
//        var currentCount: Int32 = theTimer.userInfo["currentCount"].intValue()
//
//        
//        theTimer.userInfo! ["currentCount"] = Int (currentCount)
//        
//            if currentCount > (theString.lenght - 1) {
//            theTimer.invalidate()
        }
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
