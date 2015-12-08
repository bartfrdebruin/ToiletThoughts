//
//  LoginViewController.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 26-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIImageView *loginSuccess;
@property (weak, nonatomic) IBOutlet UIButton *play;

- (IBAction)signIn:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)cancel:(id)sender;

@end
