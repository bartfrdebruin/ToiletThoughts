//
//  AddThoughtVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "AddThoughtVC.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LoginViewController.h"
#import "ListThoughtTableVC.h"


@import MobileCoreServices;

@interface AddThoughtVC ()

@property (nonatomic) CGRect normalFrame;

@end

@implementation AddThoughtVC


#pragma mark - viewDidLoad


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
//    self.view.frame = CGRectMake(0, 0, 320, 568);
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Add a Toilet Thought!";
    
    
    
    // No back button
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];
//    
//    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,400, 320, 60)];
//    [self.view addSubview:toolBar];
    
    UITextField *toolbarTextField =[[UITextField alloc]initWithFrame:CGRectMake(0, 400, 260, 30)];
    self.toolbarTextField.backgroundColor =[UIColor  whiteColor];
    self.toolbarTextField.placeholder=@"Enter your text";
    self.toolbarTextField.borderStyle = UITextBorderStyleRoundedRect;
//    toolbarTextField.delegate = toolbarTextField;
    toolbarTextField.inputAccessoryView = self.navigationController.toolbar;
    UIBarButtonItem *textfieldItem = [[UIBarButtonItem alloc]initWithCustomView:toolbarTextField];
    
    self.toolbarItems = [NSArray arrayWithObject:textfieldItem];
    
//   [toolbarTextField setInputAccessoryView:self.view];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAndGoBack)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UITapGestureRecognizer *tapOutsiteTextField = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapOutsiteTextField];
}


- (void)handleTap:(UITapGestureRecognizer *)sender {

        [self.toolbarTextField resignFirstResponder];
}



- (void)viewWillDisappear:(BOOL)animated {
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAndGoBack {
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];

    [self.navigationController pushViewController:hvc animated:YES];
    
    [UIView commitAnimations];
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

#pragma mark - textField

- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration *100];
    [UIView setAnimationCurve:animationCurve];
    
    [self.customView  setFrame:CGRectMake(self.customView.frame.origin.x, self.customView.frame.origin.y - keyboardFrame.size.height, self.customView.frame.size.width, self.customView.frame.size.height)];
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.customView setFrame:CGRectMake(self.customView.frame.origin.x, self.customView.frame.origin.y + keyboardFrame.size.height,self.customView.frame.size.width, self.customView.frame.size.height)];
    
    [UIView commitAnimations];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.toolbarTextField resignFirstResponder];
    
    return YES;
}


#pragma mark - takePicture / ImagePicker

- (IBAction)takePicture:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
    
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:self.imagePicker animated:YES completion: NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - post

- (IBAction)post:(id)sender {
    
    [self.toolbarTextField resignFirstResponder];
    [self.view endEditing:YES];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [self.toolbarTextField resignFirstResponder];
        [self.view endEditing:YES];
        
        
        PFObject *toiletThought = [PFObject objectWithClassName:@"ToiletThought"];
        [toiletThought setObject:self.thoughtTextField.text forKey:@"toiletThought"];
        
        if (self.imageView.image != nil) {
            
            // Toilet Thought Image
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.4);
            
            // Lekker image name
            NSUUID *uuid = [NSUUID UUID];
            
            PFFile *thoughtImage = [PFFile fileWithName:uuid.UUIDString data:imageData];
            [toiletThought setObject:thoughtImage forKey:@"thoughtImage"];
        }
        
        [toiletThought saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [self.view endEditing:YES];
            
            if (!error) {
                
                // Show success message
                UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload Complete" message: @"Succesfully saved your Toilet Thought!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          
                                                                          ListThoughtTableVC *listThoughtTableVC = [[ListThoughtTableVC alloc] init];
                                                                          [listThoughtTableVC retrieveFromParseRecent];
                                                                          
                                                                          if ([self.presentedFromVC isKindOfClass:[ListThoughtTableVC class]]) {
                                                                              
                                                                              [listThoughtTableVC retrieveFromParseRecent];
                                                                              [self.navigationController popViewControllerAnimated:YES];

                                                                          } else {
                                                                              
                                                                              [listThoughtTableVC retrieveFromParseRecent];
                                                                              [self.navigationController pushViewController:listThoughtTableVC animated:YES];
                                                                          }
                                                                          
                                                                      }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload failure" message: @"Failed to save your Toilet Thought!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        
    } else {
        
        UIAlertController *logOrSignIn = [UIAlertController alertControllerWithTitle:@"Sign or Log in!" message:@"If you want your thoughts to be saved, you need to Sign or Log in!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.thoughtTextField resignFirstResponder];
            [self.view endEditing:YES];
            
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel!" style:UIAlertActionStyleDefault handler:nil];
        
        [logOrSignIn addAction:okAction];
        [logOrSignIn addAction:cancelAction];
        
        [self presentViewController:logOrSignIn animated:YES completion:nil];
    }
    
}


@end
