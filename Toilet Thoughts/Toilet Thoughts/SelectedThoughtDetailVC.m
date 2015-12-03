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
    
    self.selectedThoughtDetail.alpha = 1;
    
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.selectedThoughtDetail.alpha = 0.0;
        self.selectedThoughtDetail.alpha = 0.9;
    } completion:nil];
    
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
    
    UIBarButtonItem *scoreUpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsup_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreUp)];
    
    UIBarButtonItem *scoreDownButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsdown_small"] style:UIBarButtonItemStylePlain target:self action:@selector(scoreDown)];
    
    self.toolbarItems = [NSArray arrayWithObjects: scoreDownButton, space, scoreUpButton, nil];
    
    [self.navigationController setToolbarItems:self.toolbarItems];
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
        
        NSNumber *score = [self.currentThought objectForKey:@"score"];
        self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", score];
        
    } else {
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
        
        NSNumber *score = [self.currentThought objectForKey:@"score"];
        self.selectedThoughtScore.text = [NSString stringWithFormat:@" %@", score];
        
    } else {
        
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
