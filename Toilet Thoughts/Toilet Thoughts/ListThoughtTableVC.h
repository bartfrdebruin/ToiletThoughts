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
#import "GTLYouTube.h"

@interface ListThoughtTableVC : UITableViewController

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic) int chosenList;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) NSArray *winningThoughts;
@property (nonatomic) UIViewController *presentedFromAddThoughtVC;
@property (nonatomic, strong) PFObject * currentThought;
@property (nonatomic, strong) NSArray *videoObjects;
@property (nonatomic, strong) PFObject *highestScoreObject;
@property (nonatomic, strong) GTLYouTubeChannel *taugeTVChannel;
@property (nonatomic, strong) NSArray *taugeTVPlaylist;

- (void)retrieveFromParseRecent;
- (void)retrieveFromParseScore;


@end
