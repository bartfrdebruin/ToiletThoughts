//
//  HomeViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "HomeViewController.h"
#import "ListThoughtTableVC.h"
#import "AddThoughtVC.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "NoInternetViewController.h"
#import "Reachability.h"

@interface HomeViewController ()

@property (nonatomic) Reachability *internetReachability;


@end

@implementation HomeViewController


- (IBAction)browseThoughts:(id)sender {
    
    ListThoughtTableVC *listThoughtTableVC= [[ListThoughtTableVC alloc] initWithNibName:@"ListThoughtTableVC" bundle:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:listThoughtTableVC animated:YES];
    [UIView commitAnimations];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [listThoughtTableVC retrieveFromParseScore];
    
}


- (IBAction)addThoughts:(id)sender {
    
    AddThoughtVC *addThoughtVC = [[AddThoughtVC alloc] initWithNibName:@"AddThoughtVC" bundle:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:addThoughtVC animated:YES];

    
     [UIView commitAnimations];
    
    [self.navigationController setNavigationBarHidden:NO];

    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // To set the navigationbar to normal
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSLog(@"week: %li", (long)[[calender components: NSCalendarUnitWeekOfYear fromDate:date] weekOfYear]);
    NSLog(@"yearWhereWeekIsContainedIn: %li", (long) [[calender components:NSCalendarUnitYear fromDate:date] year]);
    NSLog(@"hourOfMoment: %li", (long)[[calender components:NSCalendarUnitHour fromDate:date] hour]);
    
    self.weekOfYear = [[calender components:NSCalendarUnitWeekOfYear fromDate:date] weekOfYear];
    self.year = [[calender components:NSCalendarUnitYear fromDate:date] year]*100;
    
    self.weekAndYear = (self.weekOfYear + self.year);
    
    if (self.weekOfYear == 1) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
        [query whereKey:@"weekNumber" equalTo:@(self.weekOfYear - 49)];
        [query orderByDescending:@"score"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (objects) {
                self.highestScoreObject = objects[0];
                self.highestScoringToiletThought.text = self.highestScoreObject[@"toiletThought"];
                self.highestScoringUser.text = self.highestScoreObject[@"userName"];
                
                NSNumber *highestScoreNumber = [self.highestScoreObject objectForKey:@"score"];
                self.highestScoreNumberLabel.text = [NSString stringWithFormat:@" %@", highestScoreNumber];
            }
        }];
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    [query whereKey:@"weekNumber" equalTo:@(self.weekAndYear - 1)];
    [query orderByDescending:@"score"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (objects) {
            self.highestScoreObject = objects[0];
            self.highestScoringToiletThought.text = self.highestScoreObject[@"toiletThought"];
            self.highestScoringUser.text = self.highestScoreObject[@"userName"];
            
            // Here we create the animation to show the highest scoring thought on the Homescreen.
            NSString *string = self.highestScoringToiletThought.text;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:string forKey:@"string"];
            [dict setObject:@0 forKey:@"currentCount"];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(typingLabel:) userInfo:dict repeats:YES];
            [timer fire];
            
            NSNumber *highestScoreNumber = [self.highestScoreObject objectForKey:@"score"];
            int scoreInIntValue = [highestScoreNumber intValue];
            
            if (scoreInIntValue >= 0) {
                
                self.thumbsDown.hidden = YES;
                self.thumbsUp.hidden = NO;
                self.highestScoreNumberLabel.text = [NSString stringWithFormat:@" %@", highestScoreNumber];
                
                
            } else if (scoreInIntValue < 0) {
                
                self.thumbsUp.hidden = YES;
                self.thumbsDown.hidden = NO;
                self.highestScoreNumberLabel.text = [NSString stringWithFormat:@" %@", highestScoreNumber];
                
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // To set the navigationbar to normal
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];

}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}


- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
        self.thumbsDown.hidden = YES;
        self.thumbsUp.hidden = YES;
        NoInternetViewController *noInternetViewController = [[NoInternetViewController alloc] init];
        [self presentViewController:noInternetViewController animated:YES completion: nil];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)typingLabel:(NSTimer*)theTimer
{
    NSString *theString = [theTimer.userInfo objectForKey:@"string"];
    int currentCount = [[theTimer.userInfo objectForKey:@"currentCount"] intValue];
    currentCount ++;
    NSLog(@"%@", [theString substringToIndex:currentCount]);
    
    [theTimer.userInfo setObject:[NSNumber numberWithInt:currentCount] forKey:@"currentCount"];
    
    if (currentCount > theString.length-1) {
        [theTimer invalidate];
    }
    
    [self.highestScoringToiletThought setText:[theString substringToIndex:currentCount]];
}


@end
