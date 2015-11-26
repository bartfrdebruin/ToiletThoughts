//
//  AddThoughtVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "AddThoughtVC.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PopularThoughtsTableVC.h"
#import "LoginViewController.h"


@import MobileCoreServices;

@interface AddThoughtVC ()

@end

@implementation AddThoughtVC


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Add a Toilet Thought!";
    
    // No back button
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // Cancel button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAndGoBack)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    UITapGestureRecognizer *tapOutsiteTextField = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:tapOutsiteTextField];
}


- (void)handleTap:(UITapGestureRecognizer *)sender {

        [self.thoughtTextField resignFirstResponder];
    
}

- (void)dealloc {
    
//        unregister for keyboard notifications while not visible.
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
    
    [self.customView setFrame:CGRectMake(self.customView.frame.origin.x, self.customView.frame.origin.y + keyboardFrame.size.height, self.customView.frame.size.width, self.customView.frame.size.height)];
    
    
    [UIView commitAnimations];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.thoughtTextField resignFirstResponder];
    
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
    
    [self.thoughtTextField resignFirstResponder];

    
    UIAlertController *logOrSignIn = [UIAlertController alertControllerWithTitle:@"Sign or Log in!" message:@"If you want to save your thought you will need to be a registerd user of the Toilet Thoughts app" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [logOrSignIn addAction:okAction];
    [logOrSignIn addAction:cancelAction];
    [self presentViewController:logOrSignIn animated:YES completion:nil];

    
    
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
        
        [self.thoughtTextField resignFirstResponder];
        
        if (!error) {
            // Show success message
            UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload Complete" message: @"Succesfully saved your Toilet Thought!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      PopularThoughtsTableVC *popularThoughtsTableVC = [[PopularThoughtsTableVC alloc] init];
                                                                      [self.navigationController pushViewController:popularThoughtsTableVC animated:YES];
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

}





@end
