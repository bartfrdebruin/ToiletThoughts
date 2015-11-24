//
//  ThoughtCustomCell.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThoughtCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thoughtImageThumbnail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thoughtLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameThoughtCustomCell;
@property (weak, nonatomic) IBOutlet UILabel *scoreThoughtCustomCell;


@end
