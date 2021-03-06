//
//  UserViewController.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 26-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *userPicture;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *addThought;
@property (weak, nonatomic) IBOutlet UIButton *logOut;

@property (weak, nonatomic) IBOutlet UIButton *goToList;


@end
