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


@interface AddThoughtVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *balloon;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *thoughtTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UIButton *record;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UIButton *play1;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (nonatomic) UIViewController *presentedFromVC;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITextField *toolbarTextfield;
@property (strong, nonatomic) IBOutlet UILabel *thougtLabel;

- (IBAction)post:(id)sender;

@property (nonatomic) NSData *audioData;

@end
