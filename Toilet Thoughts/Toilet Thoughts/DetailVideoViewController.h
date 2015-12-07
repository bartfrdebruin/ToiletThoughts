//
//  DetailVideoViewController.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 04-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YTPlayerView.h"

@interface DetailVideoViewController : UIViewController <YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;

@end
