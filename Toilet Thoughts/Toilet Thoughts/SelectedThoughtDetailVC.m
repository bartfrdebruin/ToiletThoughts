//
//  SelectedThoughtDetailVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "SelectedThoughtDetailVC.h"
#import "Parse/parse.h"

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
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    UIBarButtonItem *scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsup_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
    
    UIBarButtonItem *scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsdown_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
    
    self.toolbarItems = [NSArray arrayWithObjects: scoreDownButton, space, scoreUpButton, nil];
    
    [self.navigationController setToolbarItems:self.toolbarItems];
}


- (void)scoreUp {
        
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
         PFObject *toiletThought = [PFObject objectWithClassName:@"ToiletThought"];
        [toiletThought setObject:@0 forKey:@"score"];

   
    } else {
        
        
    }

    
    
    
}



@end
