//
//  DetailVideoViewController.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 04-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <Parse/Parse.h>

@interface DetailVideoViewController : UIViewController <YTPlayerViewDelegate>

@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) NSArray *videoObjects;
@property (nonatomic, strong) PFObject *currentWinningThought;
@property (strong, nonatomic) IBOutlet UILabel *taugeTVIntroduction;
@property (strong, nonatomic) IBOutlet UITextView *winningToiletThought;
@property (strong, nonatomic) IBOutlet UILabel *winningUser;
@property (strong, nonatomic) IBOutlet UILabel *winningScore;



- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;

@end
