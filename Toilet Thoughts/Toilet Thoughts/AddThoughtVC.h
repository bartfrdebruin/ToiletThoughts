//
//  AddThoughtVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>


@interface AddThoughtVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *thoughtTextField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *record;
@property (weak, nonatomic) IBOutlet UIButton *play;

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (nonatomic) UIViewController *presentedFromVC;
@property (strong, nonatomic) PFUser *currentUser;


@property(strong, nonatomic) UITextField *toolbarTextfield;

- (IBAction)post:(id)sender;

@end
