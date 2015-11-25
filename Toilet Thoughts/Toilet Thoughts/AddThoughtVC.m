//
//  AddThoughtVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "AddThoughtVC.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PopularThoughtsTableVC.h"


@import MobileCoreServices;

@interface AddThoughtVC ()

@end

@implementation AddThoughtVC


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Add a Toilet Thought!";
    
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
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
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
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    [UIView commitAnimations];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.thoughtTextField resignFirstResponder];
    
    return YES;
}


#pragma mark - takePicture

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

- (IBAction)post:(id)sender {
    
    
    
    PFObject *toiletThought = [PFObject objectWithClassName:@"ToiletThought"];
    
    [toiletThought setObject:self.thoughtTextField.text forKey:@"toiletThought"];
    
    [toiletThought saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self.thoughtTextField resignFirstResponder];

        
                if (!error) {
                    // Show success message
                    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload Complete" message: @"Succesfully saved your Toilet Thought!" preferredStyle:UIAlertControllerStyleAlert];
        
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              
                                                                               PopularThoughtsTableVC *popularThoughtsTableVC = [[PopularThoughtsTableVC alloc] init];
                                                                              
                                                                              NSAssert(self.presentingViewController != nil, @"PresentingViewController is nil");
//                                                                              NSAssert(self.presentingViewController.navigationController != nil, @"All this is nil");
                                                                              
                                                                              [(UINavigationController *)self.presentingViewController pushViewController:popularThoughtsTableVC animated:NO];
                                                                                                                                                            
                                                                              [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

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

    

    

//    
//    [toiletThought saveAllInBackground: target:<#(nullable id)#> selector:<#(nullable SEL)#>]
//    [PFObject: block:^(BOOL succeeded, NSError * _Nullable error) {
//        <#code#>
//    }]
//    
//}
//
////- (void)saveLekker:(PFObject *)lekker {
////    
////    [lekker saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////        
////        if (!error) {
////            // Show success message
////            UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload Complete" message: @"Successfully saved your #Lekker post!" preferredStyle:UIAlertControllerStyleAlert];
////            
////            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
////                                                                  handler:^(UIAlertAction * action) {}];
////            [alert addAction:defaultAction];
////            
////            [self presentViewController:alert animated:YES completion:nil];
////            
////        } else {
////            UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload failure" message: @"Failed to save your #Lekker post!" preferredStyle:UIAlertControllerStyleAlert];
////            
////            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
////                                                                  handler:^(UIAlertAction * action) {}];
////            
////            [alert addAction:defaultAction];
////            
////            [self presentViewController:alert animated:YES completion:nil];
////        }
////    }];
////    
////}

@end
