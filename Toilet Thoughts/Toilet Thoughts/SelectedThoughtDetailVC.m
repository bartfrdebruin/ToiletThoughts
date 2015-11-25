//
//  SelectedThoughtDetailVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "SelectedThoughtDetailVC.h"
#import "PopularThoughtsTableVC.h"

@interface SelectedThoughtDetailVC ()

@end

@implementation SelectedThoughtDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Thought";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    self.selectedThoughtImage.file = self.thoughtImageFile;
    self.selectedThoughtDetail.text = self.thoughtDetail;
    
    self.selectedThoughtDetail.alpha = 1;
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.selectedThoughtDetail.alpha = 0.0;
        self.selectedThoughtDetail.alpha = 0.9;
    } completion:nil];
   
    self.selectedThoughtScore.text = self.thoughtScore;
    
//    self.selectedThoughtScore.hidden = NO;
//    self.selectedThoughtScore.alpha = 0.7;
//    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
//        self.selectedThoughtScore.alpha = 0.0;
//        self.selectedThoughtScore.alpha = 0.9;
//    } completion:nil];

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
