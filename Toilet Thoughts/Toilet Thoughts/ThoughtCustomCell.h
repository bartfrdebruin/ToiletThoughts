//
//  ThoughtCustomCell.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface ThoughtCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *thoughtImageThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *usernameThoughtCustomCell;
@property (weak, nonatomic) IBOutlet UILabel *scoreThoughtCustomCell;
@property (weak, nonatomic) IBOutlet UILabel *thoughtLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
