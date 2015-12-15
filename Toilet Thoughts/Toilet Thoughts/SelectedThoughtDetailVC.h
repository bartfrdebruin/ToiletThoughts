//
//  SelectedThoughtDetailVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <AVFoundation/AVFoundation.h>

@interface SelectedThoughtDetailVC : UIViewController <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedThoughtScore;
@property (weak, nonatomic) IBOutlet PFImageView *selectedThoughtImage;
@property (weak, nonatomic) IBOutlet UILabel *selectedThoughtDetail;
@property (weak, nonatomic) IBOutlet UIImageView *thoughtBalloon;
@property (weak, nonatomic) IBOutlet UIButton *playAudioThought;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NSTimer *audioTimer;
@property (nonatomic, strong) PFFile *thoughtImageFile;
@property (nonatomic, strong) PFFile *audioThought;
@property (strong,nonatomic) NSString *thoughtDetail;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSNumber *scoreNumber;
@property (nonatomic) BOOL hasUserVotedDown;
@property (nonatomic) BOOL hasUserVotedUp;
@property (nonatomic, strong) PFObject *currentThought;
@property (nonatomic, strong) PFObject *userObject;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) UIBarButtonItem *scoreUpButton;
@property (nonatomic, strong) UIBarButtonItem *scoreDownButton;
@property (nonatomic, strong) UIBarButtonItem *shareButton;

@end
