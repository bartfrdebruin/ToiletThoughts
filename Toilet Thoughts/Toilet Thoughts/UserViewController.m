//
//  UserViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 26-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>


@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"User Name";
    self.navigationController.navigationBarHidden = YES;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];
}

- (IBAction)logOut:(id)sender {
    
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Log out?" message: @"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              HomeViewController *hvc = [[HomeViewController alloc] init];
                                                              [self.navigationController pushViewController:hvc animated:yes];
                                                          
                                                          }];
    [alert addAction:cancel];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:YES completion:nil];

    [PFUser logOut];
}

- (IBAction)back:(id)sender {
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:hvc animated:YES];
    
}

@end
