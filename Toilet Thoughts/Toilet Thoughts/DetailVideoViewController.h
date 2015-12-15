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
@property (strong, nonatomic) IBOutlet UITextView *taugeTVIntroduction;
@property (strong, nonatomic) IBOutlet UITextView *winningToiletThought;
@property (strong, nonatomic) IBOutlet UILabel *winningUser;
@property (strong, nonatomic) IBOutlet UILabel *winningScore;
@property (strong, nonatomic) IBOutlet UIImageView *thumbUp;
//@property (strong, nonatomic) IBOutlet UIImageView *thumbDown;





- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;

@end
