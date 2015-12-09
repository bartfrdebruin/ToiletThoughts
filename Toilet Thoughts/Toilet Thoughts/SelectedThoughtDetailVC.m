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

@interface SelectedThoughtDetailVC ()

@end

@implementation SelectedThoughtDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Toilet Thought";
    
    // Checking the current user
    PFUser *currentUser = [PFUser currentUser];
    
    
    // Login button
    if (currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"person_loggedIn_small"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    else {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"person_small.png"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    self.scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsup_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
    self.scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsdown_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
    
    self.toolbarItems = [NSArray arrayWithObjects: self.scoreDownButton, space, self.scoreUpButton, nil];
    
//    // Toolbar
//    [self.navigationController setToolbarHidden:NO];
//    [self.navigationController setToolbarItems:self.toolbarItems];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *savedVote = [defaults objectForKey:self.currentThought.objectId];
//    
//    
//    // If the user has posted an up or down vote
//    if ([savedVote isEqualToString:@"voteDown"]) {
//        
//        self.scoreDownButton.enabled = NO;
//        self.scoreUpButton.enabled = YES;
//        
//     
//    } else if ([savedVote isEqualToString:@"voteUp"]) {
//        
//        self.scoreUpButton.enabled = NO;
//        self.scoreDownButton.enabled = YES;
//        
//    } else {
//        
//    }
    
    
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


#pragma mark - score up score down user is wrong

- (void)userIsWrong {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedVote = [defaults objectForKey:self.currentThought.objectId];
    
    // If the user has posted an up or down vote
    if ([savedVote isEqualToString:@"voteDown"]) {
        
        self.scoreDownButton.enabled = NO;
        self.scoreUpButton.enabled = YES;
        
    } else if ([savedVote isEqualToString:@"voteUp"])
        
        self.scoreDownButton.enabled = YES;
        self.scoreUpButton.enabled = NO;

}


- (void)scoreDown {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSString *user = [self.currentThought objectForKey:@"userName"];
        
        // If user has not posted the thought himself, he can upvote the thought
        if (![[self.currentThought objectForKey:@"userName"] isEqualToString:currentUser.username]) {
      
            
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
            self.hasUserVotedDown = YES;
            
            self.scoreNumber = [self.currentThought objectForKey:@"score"];
            self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", self.scoreNumber];
            
        }
        if (self.hasUserVotedDown) {
            
            self.scoreDownButton.enabled = NO;
            self.scoreUpButton.enabled = YES;
            
            NSString *voteDown = @"voteDown";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:voteDown forKey:self.currentThought.objectId];
            [defaults synchronize];
            
             }
    }
    
    else {
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
        
        if (![[self.currentThought objectForKey:@"userName"] isEqualToString:currentUser.username]) {
        
            
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
            self.hasUserVotedUp = YES;

            NSNumber *score = [self.currentThought objectForKey:@"score"];
            self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", score];
        }
        
        if (self.hasUserVotedUp) {
            self.scoreUpButton.enabled = NO;
            self.scoreDownButton.enabled = YES;
            
            NSString *voteUp = @"voteUp";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:voteUp forKey:self.currentThought.objectId];
            [defaults synchronize];
        }
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not logged in!"
                                                                       message:@"You need to be logged in to vote up or down!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

@end
