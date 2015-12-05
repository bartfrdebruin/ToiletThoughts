//
//  ListThoughtTableVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 01-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ListThoughtTableVC.h"
#import "WinningThoughtCustomVideoCell.h"
#import "ThoughtCustomCell.h"

@interface ListThoughtTableVC : UITableViewController

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic) int chosenList;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) NSArray *winningThoughts;
@property (nonatomic) UIViewController *presentedFromAddThoughtVC;
@property (nonatomic, strong) PFObject * currentThought;

- (void)retrieveFromParseRecent;
- (void)retrieveFromParseScore;


@end
