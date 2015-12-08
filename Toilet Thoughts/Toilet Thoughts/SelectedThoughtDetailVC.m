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
    
    PFUser *currentUser = [PFUser currentUser];
    
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
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    
    self.scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsup_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
    
    self.scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsdown_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
    
    self.toolbarItems = [NSArray arrayWithObjects: self.scoreDownButton, space, self.scoreUpButton, nil];
    
    [self.navigationController setToolbarItems:self.toolbarItems];

    if([[NSUserDefaults standardUserDefaults] boolForKey:self.currentThought.objectId]) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userVotedDown"]) {
            
            self.scoreDownButton.enabled = NO;

        } else {
        
            self.scoreUpButton.enabled = NO;
        }
    }

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.selectedThoughtDetail.alpha = 0.0;
        self.thoughtBalloon.alpha = 0.0;
    } completion:nil];
}


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
            
        } if (self.hasUserVotedDown) {
            
            self.scoreDownButton.enabled = NO;
            
//            NSString *currentThoughtObject = self.currentThought objectForKey:@""
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:self.currentThought.objectId];
            [defaults setBool:YES forKey:@"userVotedDown"];
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
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:self.currentThought.objectId];
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
