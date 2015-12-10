//
//  HomeViewController.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface HomeViewController : UIViewController 

@property (strong, nonatomic) UIViewController *homevc;
@property (nonatomic) NSInteger weekOfYear;
@property (nonatomic) NSInteger weekAndYear;
@property (nonatomic) NSInteger week;
@property (nonatomic) NSInteger year;
@property (strong, nonatomic) IBOutlet UILabel *highestScoringToiletThought;
@property (nonatomic, strong) PFObject *highestScoreObject;
@property (strong, nonatomic) IBOutlet UILabel *highestScoringUser;
@property (strong, nonatomic) IBOutlet UILabel *highestScoreNumberLabel;



@end
