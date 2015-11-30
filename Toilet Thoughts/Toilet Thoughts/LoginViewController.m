//
//  LoginViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 26-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "LoginViewController.h"
#import "AddThoughtVC.h"
#import <Parse/Parse.h>
#import "AddThoughtVC.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    return YES;
}


- (IBAction)signIn:(id)sender {
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.view endEditing:YES];

    
    PFUser *user = [PFUser user];
    user.username = self.userName.text;
    user.password = self.passWord.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
        }
    }];
}

- (IBAction)logIn:(id)sender {
        
    [PFUser logInWithUsernameInBackground:self.userName.text password:self.passWord.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                            [self.userName resignFirstResponder];
                                            [self.passWord resignFirstResponder];
                                            
                                            [self.view endEditing:YES];

                                        
                                        } else {

                                        
                                        }
                                    }];
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


    
    

@end
