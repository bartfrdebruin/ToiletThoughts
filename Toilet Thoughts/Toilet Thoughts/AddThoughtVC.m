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
#import <AVFoundation/AVFoundation.h>
#import "LEMirroredImagePicker.h"
#import "SelectedThoughtDetailVC.h"

@import MobileCoreServices;

@interface AddThoughtVC ()

@property (nonatomic) CGRect normalFrame;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;
@property(nonatomic) LEMirroredImagePicker *mirrorFrontPicker;
@property (nonatomic) NSData *audioData;

@end

@implementation AddThoughtVC

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"New";
    self.toolbarTextfield.delegate = self;
    
    // No back button
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];
    
    // Audio recording settings
    
    self.play.hidden = YES;
    
    [ self.record addTarget:self
                     action:@selector(methodTouchDown:)
           forControlEvents:UIControlEventTouchDown];
    
    [self.record addTarget:self
                    action:@selector(methodTouchUpInside:)
          forControlEvents: UIControlEventTouchUpInside];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemoTemp.m4a",
                               nil];
    
    NSURL *outputFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordString = [[NSMutableDictionary alloc]init];
    
    [recordString setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordString setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [recordString setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:outputFileUrl settings:recordString error:nil];
    
    self.recorder.delegate = self;
    
    self.recorder.meteringEnabled = YES;
    
    [self.recorder prepareToRecord];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAndGoBack)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UITapGestureRecognizer *tapOutsiteTextField = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapOutsiteTextField];
}

# pragma mark - viewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE ACTIVE"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    else {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE PASSIVE"] forState:UIControlStateNormal];
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

# pragma mark - viewDidAppear

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    
}


- (void)handleTap:(UITapGestureRecognizer *)sender {

        [self.toolbarTextfield resignFirstResponder];
        [self.view endEditing:YES];
}

# pragma mark - viewWillDisappear

- (void)viewWillDisappear:(BOOL)animated {
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - cancelAndGoBack

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

# pragma mark - goToUserScreen

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

#pragma mark - keyboardWillShow

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
    
    [self.view  setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

# pragma mark - keyboardWillHide

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
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height,self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

#pragma mark - textfields

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.toolbarTextfield endEditing:YES];
    [self.toolbarTextfield resignFirstResponder];
//
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [self.toolbarTextfield.text stringByReplacingCharactersInRange:range withString:string];
    [self updateTextLabelsWithText: newString];
    
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    [self.thougtLabel setText:string];
}


#pragma mark - takePicture / ImagePicker

- (IBAction)takePicture:(id)sender {
    
        self.imagePicker = [[UIImagePickerController alloc] init];
    
    self.mirrorFrontPicker = [[LEMirroredImagePicker alloc] initWithImagePicker:self.imagePicker];
    [self.mirrorFrontPicker mirrorFrontCamera];
    
    UIImageView *overlayView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Thought vlak iphone 6"]];
    
        [overlayView.layer setOpaque:NO];
        overlayView.opaque = NO;

    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
    self.imagePicker.cameraOverlayView = overlayView;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    // self.imagePicker.showsCameraControls = NO;
    
    
    // Place image picker on the screen
    [self presentViewController:self.imagePicker animated:YES completion: NULL];
}

#pragma mark - imagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Add a watermark to the pictures.
    UIImage *watermark = [UIImage imageNamed:@"TaugeTvLogo"];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [watermark drawInRect:CGRectMake(image.size.width - watermark.size.width, image.size.height - watermark.size.height, watermark.size.width, watermark.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = result;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - post

- (IBAction)post:(id)sender {
    
    if ([self.toolbarTextfield.text  isEqual: @""]){
        self.warningLabel.alpha = 1;
        
        CGPoint point = CGPointMake(self.thoughtTextField.center.x + 10, self.thoughtTextField.center.y + 5);
        CGPoint original = CGPointMake(self.thoughtTextField.center.x, self.thoughtTextField.center.y);
        
        self.thoughtTextField.placeholder = @"";
        
        self.warningLabel.hidden = NO;
        [UIView animateWithDuration:4.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.warningLabel.alpha = 0.0;
            
        }completion:nil];
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.thoughtTextField.center = point;
        }completion:nil];
        self.thoughtTextField.center = original;
        
    }
    
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"MyAudioMemoTemp.m4a",
//                               nil];
//    
//    NSString * path = [pathComponents[0] stringByAppendingPathComponent:@"MyAudioMemoTemp.m4a"];
//    
//    NSData * audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
//    
//    PFObject * myTestObject = [PFObject objectWithClassName:@"ToiletThought"];
//    
//    PFFile * audioFile = [PFFile fileWithName:@"MyAudioMemoTemp.m4a" data:audioData];
//    
//    myTestObject[@"audioFile"] = audioFile;
//    [myTestObject saveInBackground];
    
    [self.toolbarTextfield resignFirstResponder];
    [self.view endEditing:YES];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"MyAudioMemoTemp.m4a",
                                   nil];
        
        NSString * path = [pathComponents[0] stringByAppendingPathComponent:@"MyAudioMemoTemp.m4a"];
        
        self.audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
        
        PFObject * myTestObject = [PFObject objectWithClassName:@"ToiletThought"];
        
        PFFile * audioFile = [PFFile fileWithName:@"MyAudioMemoTemp.m4a" data:self.audioData];
        
        myTestObject[@"audioFile"] = audioFile;
        [myTestObject saveInBackground];
        
        [self.toolbarTextfield resignFirstResponder];
        [self.view endEditing:YES];
        
//        SelectedThoughtDetailVC *STDVC = [[SelectedThoughtDetailVC alloc]init];
        
        NSString *user = currentUser.username;
        
        PFObject *toiletThought = [PFObject objectWithClassName:@"ToiletThought"];
        [toiletThought setObject:self.thoughtTextField.text forKey:@"toiletThought"];
        [toiletThought setObject:@0 forKey:@"score"];
        [toiletThought setObject:user forKey:@"userName"];
//        [toiletThought setObject:STDVC.audioThoughtFile forKey:@"audioFile"];
    
        
        PFObject *totalScore = [PFObject objectWithClassName:@"TotalScore"];
        [totalScore setObject:user forKey:@"userName"];
        [totalScore setObject:@0 forKey:@"totalScore"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
        
        [query whereKey:@"userName" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
            if (objects.count == 0) {
                
                [totalScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@"succes");
                    }
                }];
            }
        }];

        if (self.imageView.image != nil) {
            
            // Toilet Thought Image
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.4);
            
            // Lekker image name
            NSUUID *uuid = [NSUUID UUID];
            
            PFFile *thoughtImage = [PFFile fileWithName:uuid.UUIDString data:imageData];
            [toiletThought setObject:thoughtImage forKey:@"thoughtImage"];
        
        
//        if (self.audioData != nil) {
//            
//            PFFile * audioFile = [PFFile fileWithName:@"MyAudioMemoTemp.m4a" data:self.audioData];
//            [toiletThought setObject:audioFile forKey:@"audioFile"];
//            
//            NSLog(@"no audio");
//        }
            
        }
    
        [toiletThought saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [self.view endEditing:YES];
            
            if (!error) {
                
                // Show success message
                UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Upload Complete" message: @"Succesfully saved your Toilet Thought!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          
                                                                          ListThoughtTableVC *listThoughtTableVC = [[ListThoughtTableVC alloc] init];
                                                                          
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

#pragma mark - IBAction recordPressed

- (IBAction)recordPressed:(id)sender {
    
    if (self.player.playing)
    {
        [self.player stop];
    }
    
    if (!self.recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setActive:YES error:nil];
        
        [self.recorder record];
        
        [self.record setTitle:@"Pause" forState:UIControlStateNormal];
        
        [self.recorder record];
        
    }
    
    else
    {
        [self.recorder pause];
        [self.record setTitle:@"Record" forState:UIControlStateNormal];
    }
    
}

#pragma mark - IBAction playTapped

- (IBAction)playTapped:(id)sender {
    
    if (!self.recorder.recording) {
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recorder.url error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

#pragma mark - methodTouchDown

-(void)methodTouchDown:(id)sender{
    
    if (self.player.playing)
    {
        [self.player stop];
        
    }
    
    if (!self.recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setActive:YES error:nil];
        
        [self.recorder record];
        
        [self.record setTitle:@"Recording" forState:UIControlStateNormal];
        
    }
    
    else
    {
        [self.recorder pause];
        [self.record setTitle:@"Record" forState:UIControlStateNormal];
    }

    
    NSLog(@"TouchDown");
}


#pragma mark - methodTouchUpInside

-(void)methodTouchUpInside:(id)sender{
    
    [self.recorder stop];
    
    self.play.hidden = NO;
    self.record.hidden = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemoTemp.m4a",
                               nil];
    
    NSString * path = [pathComponents[0] stringByAppendingPathComponent:@"MyAudioMemoTemp.m4a"];
    
    self.audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    
//    PFObject * myTestObject = [PFObject objectWithClassName:@"ToiletThought"];
//    
//    PFFile * audioFile = [PFFile fileWithName:@"MyAudioMemoTemp.m4a" data:self.audioData];
//    
//    myTestObject[@"audioFile"] = audioFile;
//    [myTestObject saveInBackground];
    
    NSLog(@"TouchUpInside");
}


@end
