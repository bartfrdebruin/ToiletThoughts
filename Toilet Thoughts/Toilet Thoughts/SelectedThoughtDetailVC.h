//
//  SelectedThoughtDetailVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface SelectedThoughtDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *selectedThoughtImage;
@property (weak, nonatomic) IBOutlet UILabel *selectedThoughtDetail;

@property (nonatomic) PFFile *thoughtImageFile;
@property (strong,nonatomic) NSString *thoughtDetail;

@end
