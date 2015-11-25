//
//  AddThoughtVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddThoughtVC : UIViewController

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *thoughtTextField;
- (IBAction)post:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end
