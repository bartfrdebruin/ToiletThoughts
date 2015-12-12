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

    NSDictionary *playerVars = @{ @"playsinline" : @1,};
    [self.playerView loadWithVideoId:self.currentWinningThought[@"winningThoughtID"]playerVars:playerVars];
    
    self.toiletThought.text = self.currentWinningThought[@"winningText"];
    self.winningUser.text = self.currentWinningThought[@"winningUser"];
    
    NSNumber *score = [self.currentWinningThought objectForKey:@"winningScore"];
    self.winningScore.text = [NSString stringWithFormat:@" %@", score];
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
