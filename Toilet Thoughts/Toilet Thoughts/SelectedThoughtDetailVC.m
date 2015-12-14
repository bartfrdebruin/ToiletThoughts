//
//  SelectedThoughtDetailVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "SelectedThoughtDetailVC.h"
#import "Parse/parse.h"
#import "ListThoughtTableVC.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SYWaveformPlayerView.h"

@interface SelectedThoughtDetailVC ()

@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

@end

@implementation SelectedThoughtDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Toilet Thought";
     [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
//    self.audioThought = self.currentThought[@"audioFile"];
    
    [self.audioThought getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            
//            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
//            NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"m"]];
            
//            NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"m"];
            
//            array = [NSArray arrayWithObjects:
//                                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],
//                                       @"MyAudioMemoTemp.m4a",
//                                       nil];
//            
//            NSURL *outoutputFileUrl = [NSURL fileURLWithPathComponents:array];
            
//            NSFileManager *manager = [NSFileManager defaultManager];
//            [manager createFileAtPath:tempFilePath contents:data attributes:nil];
//            
//            NSURL *audioUrl = [NSURL URLWithString:tempFilePath];
            [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
            NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
            NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"file.txt"];
            NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
            NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
            [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&error];
            
            [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];

            NSError *error = nil;
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
            
            
                SYWaveformPlayerView *playerView = [[SYWaveformPlayerView alloc] initWithFrame:CGRectMake(40, 110, self.view.frame.size.width-70, 50) asset:asset color:[UIColor blackColor] progressColor:[UIColor colorWithRed:207 green:0 blue:126 alpha:1]];
            [self.view addSubview:playerView];
//            });
            
            
        }
    }];
    
    
    
    
    
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"MyAudioMemoTemp.m4a",
//                               nil];
//
//    NSURL *outputFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
//    NSURL *audioUrl = [NSURL URLWithString:self.audioThought.url];
    
//    NSURL *fileURL = [[outputFileUrl URLByAppendingPathComponent:@"MyAudioMemoTemp"] URLByAppendingPathExtension:@"m4a"];
    
//    NSData *urlData = [NSData dataWithContentsOfURL:outputFileUrl];
//    [urlData writeToFile:fileURL options:NSAtomicWrite error:nil];
//    [urlData writeToURL:outputFileUrl options:NSAtomicWrite error:nil];
    
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outputFileUrl options:nil];
//
//    SYWaveformPlayerView *playerView = [[SYWaveformPlayerView alloc] initWithFrame:CGRectMake(40, 110, self.view.frame.size.width-70, 50) asset:asset color:[UIColor lightGrayColor] progressColor:[UIColor colorWithRed:207 green:0 blue:126 alpha:1]];
//        [self.view addSubview:playerView];
    
    // Checking the current user
    PFUser *currentUser = [PFUser currentUser];
    
    
    // Login button
    if (currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE ACTIVE"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    else {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE PASSIVE"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedVote = [defaults objectForKey:self.currentThought.objectId];
    
    if ([savedVote isEqualToString:@"voteDown"]) {
     
        self.scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumb down inverse ACTIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
        
        self.scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Thumb up WHITE PASSIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
        self.scoreDownButton.enabled = NO;
        
    } else if ([savedVote isEqualToString:@"voteUp"]){
        
        self.scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumb down WHITE PASSIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
        
        self.scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Thumb up inverse ACTIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
        self.scoreUpButton.enabled = NO;

        
    } else {
        
        self.scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumb down WHITE PASSIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
        
        self.scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Thumb up WHITE PASSIVE"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
    }
      
    
//    // ScoreLabel programmatically
//    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    NSNumber *score = [self.currentThought objectForKey:@"score"];
//    scoreLabel.text = [NSString stringWithFormat:@" %@", score];
//    scoreLabel.numberOfLines = 1;
//    scoreLabel.textColor = [UIColor whiteColor];
//        
//    UIBarButtonItem *displayScoreButton = [[UIBarButtonItem alloc] initWithCustomView:scoreLabel];

    self.toolbarItems = [NSArray arrayWithObjects: self.scoreDownButton, space, self.scoreUpButton, nil];
    
    // If user has posted the thought himself, he cannot upvote the thought
    if ([[self.currentThought objectForKey:@"userName"] isEqualToString:currentUser.username]) {
        
        self.scoreDownButton.enabled = NO;
        self.scoreUpButton.enabled = NO;
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.selectedThoughtImage.file = self.thoughtImageFile;
    self.selectedThoughtDetail.text = self.thoughtDetail;
    
    
    NSNumber *score = [self.currentThought objectForKey:@"score"];
    self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", score];
    
    self.thoughtBalloon.alpha = 1;
    
    self.selectedThoughtDetail.alpha = 1;
    
    [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.selectedThoughtDetail.alpha = 0.0;
        self.thoughtBalloon.alpha = 0.0;
        self.selectedThoughtDetail.alpha = 1;
        self.thoughtBalloon.alpha = 1;
    } completion:nil];
}

#pragma mark - loading new viewcontrollers

- (void)goToUserScreen {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        UserViewController * userViewController = [[UserViewController alloc] init];
        [self.navigationController pushViewController: userViewController animated:YES];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}


#pragma mark - score up score down

- (void)scoreDown {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSString *user = [self.currentThought objectForKey:@"userName"];
        
        // If user has not posted the thought himself, he cannot downvote the thought
        if (![[self.currentThought objectForKey:@"userName"] isEqualToString:currentUser.username]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *savedVote = [defaults objectForKey:self.currentThought.objectId];
            
            // Voting down after having voted up
            if ([savedVote isEqualToString:@"voteUp"]) {
                
                PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
                [query whereKey:@"userName" equalTo:user];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    
                    if (object) {
                        
                        PFObject *userObject = object;
                        [userObject incrementKey:@"totalScore" byAmount:@-2];
                        [userObject saveInBackground];
                    }
                }];
                
                [self.currentThought incrementKey:@"score" byAmount:@ -2];
                [self.currentThought saveInBackground];
                self.scoreUpButton.enabled = YES;
                
            } else {
            
            // Voting down for the first time
            PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
            [query whereKey:@"userName" equalTo:user];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                
                if (object) {
                    
                    PFObject *userObject = object;
                    [userObject incrementKey:@"totalScore" byAmount:@-1];
                    [userObject saveInBackground];
                }
            }];
            
            [self.currentThought incrementKey:@"score" byAmount:@ -1];
            [self.currentThought saveInBackground];            
            }
            
            self.scoreNumber = [self.currentThought objectForKey:@"score"];
            self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", self.scoreNumber];
            
            self.scoreDownButton.image = [UIImage imageNamed:@"thumb down inverse ACTIVE"];
            self.scoreUpButton.image = [UIImage imageNamed:@"Thumb up WHITE PASSIVE"];
            self.scoreDownButton.enabled = NO;
            
            NSString *voteDown = @"voteDown";
            
            [defaults setObject:voteDown forKey:self.currentThought.objectId];
            [defaults synchronize];
            
        }
        }
    
    else {
        // Not logged in
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not logged in!"
                                                                       message:@"You need to be logged in to vote up or down!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)scoreUp {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSString *user = [self.currentThought objectForKey:@"userName"];
        
        // If user has not posted the thought himself, he cannot upvote the thought
        if (![[self.currentThought objectForKey:@"userName"] isEqualToString:currentUser.username]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *savedVote = [defaults objectForKey:self.currentThought.objectId];
            
            if ([savedVote isEqualToString:@"voteDown"]) {

            // Upvoting after having downvoted
            PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
            [query whereKey:@"userName" equalTo:user];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                
                if (object) {
                    
                    PFObject *userObject = object;
                    [userObject incrementKey:@"totalScore" byAmount:@2];
                    [userObject saveInBackground];
                    }
            }];
            
            [self.currentThought incrementKey:@"score" byAmount:@2];
            [self.currentThought saveInBackground];
                
                self.scoreDownButton.enabled = YES;
                
            } else {
                
                // Upvoting for the first time
                PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
                [query whereKey:@"userName" equalTo:user];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    
                    if (object) {
                        
                        PFObject *userObject = object;
                        [userObject incrementKey:@"totalScore" byAmount:@1];
                        [userObject saveInBackground];
                    }
                }];
                
                [self.currentThought incrementKey:@"score" byAmount:@1];
                [self.currentThought saveInBackground];
                
            }

            NSNumber *score = [self.currentThought objectForKey:@"score"];
            self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", score];
        
            self.scoreUpButton.image = [UIImage imageNamed:@"Thumb up inverse ACTIVE"];
            self.scoreDownButton.image = [UIImage imageNamed:@"thumb down WHITE PASSIVE"];
            self.scoreUpButton.enabled = NO;
            
            NSString *voteUp = @"voteUp";
            
            [defaults setObject:voteUp forKey:self.currentThought.objectId];
            [defaults synchronize];
        }
    }
    else {
        
        // Not logged in
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not logged in!"
                                                                       message:@"You need to be logged in to vote up or down!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)playTapped:(id)sender {
    
    NSLog(@"play tapped");
    
    self.audioThought = self.currentThought[@"audioFile"];

    
    [self.audioThought getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            self.player = [[AVAudioPlayer alloc] initWithData:data
                                                        error:&error];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            
            
//            AVAsset *audio = [AVAsset assetWithURL:self.audioThoughtFile.url];
//            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: audio];
            
            [self.player setVolume:1.0];
            [self.player setDelegate:self];
            [self.player play];
        }
    }];
    NSError *error;
    
    
    
    if (error)
        NSLog(@"Error: %@",
              [error localizedDescription]);

    
}



@end
