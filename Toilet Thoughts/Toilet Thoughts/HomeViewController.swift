//
//  HomeViewController.swift
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 17-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
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
        
        var date: NSDate = NSDate()
        var calender: NSCalendar = NSCalendar.currentCalendar()
        
        self.weekOfYear = calender.components(.WeekOfYear, fromDate:date).weekOfYear
        self.year = calender.components(.Year, fromDate: date).year * 100
        self.weekAndYear = (self.weekOfYear + self.year)
        
        if (self.weekOfYear == 1) {
            
            var query = PFQuery(className: "ToiletThought")
            query.whereKey("weekNumber", equalTo: self.weekOfYear - 49)
            query.orderByDescending("score")
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject], error: NSError?)  -> Void in
                
                if (objects != nil) {
                    
                    self.highestScoreObject = objects[0]
                    self.highestScoringToiletThought = self.highestScoreObject["toiletThought"]
                    self.highestScoringUser = self.highestScoreObject["userName"]
                }
            }
            
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [PFObject], error: NSError?) -> Void in
//                
//                if (objects != nil) {
//                    
//                    self.highestScoreObject = objects![0]
//                    self.highestScoringToiletThought?.text = self.highestScoreObject["toiletThought"]
//                    self.highestScoringUser.text = self.highestScoreObject["userName"]
//                
//                    
//                }
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
