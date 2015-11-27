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
- (IBAction)logOut:(id)sender {
    
    
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
}
- (IBAction)back:(id)sender {
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    
    [self.navigationController pushViewController:hvc animated:YES];
    
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
