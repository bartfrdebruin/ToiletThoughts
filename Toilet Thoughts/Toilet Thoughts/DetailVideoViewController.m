//
//  DetailVideoViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 04-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "TAAYouTubeWrapper.h"
#import "GTLYouTube.h"

@interface DetailVideoViewController ()

@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Toilet Winners";
    [self.navigationController setToolbarHidden:YES];

    self.playerView.delegate = self;

    NSDictionary *playerVars = @{ @"playsinline" : @1,
                                  @"showinfo" : @0};
    [self.playerView loadWithVideoId:self.currentWinningThought[@"winningYouTubeVideoThoughtID"]playerVars:playerVars];
    
    self.winningToiletThought.text = self.currentWinningThought[@"toiletThought"];
    self.winningUser.text = self.currentWinningThought[@"userName"];
    self.taugeTVIntroduction.text = self.currentWinningThought[@"taugeTVIntroduction"];


    NSNumber *score = [self.currentWinningThought objectForKey:@"score"];
    self.winningScore.text = [NSString stringWithFormat:@" %@", score];
    
    int scoreInIntValue = [score intValue];
    
    if (scoreInIntValue >= 0) {
        
        self.thumbDown.hidden = YES;
        self.thumbUp.hidden = NO;
        self.winningScore.text = [NSString stringWithFormat:@" %@", score];


        
    } else if (scoreInIntValue < 0) {
        
        self.thumbUp.hidden = YES;
        self.thumbDown.hidden = NO;
        self.winningScore.text = [NSString stringWithFormat:@" %@", score];

    }
}


- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    [self.playerView playVideo];
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"Paused playback");
            break;
        default:
            break;
    }
}

- (IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}




@end
