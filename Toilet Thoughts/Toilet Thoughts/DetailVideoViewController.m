//
//  DetailVideoViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 04-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "DetailVideoViewController.h"

@interface DetailVideoViewController ()

@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Toilet Winners";
    
    
    self.playerView.delegate = self;
    
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [self.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
