//
//  WinningThoughtCustomVideoCell.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface WinningThoughtCustomVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameWinningThoughtCVC;
@property (weak, nonatomic) IBOutlet UILabel *scoreWinningThoughtCVC;
@property (weak, nonatomic) IBOutlet PFImageView *thumbnailWinningThoughtCVC;
@property (weak, nonatomic) IBOutlet UILabel *thoughtWinningThoughtCVC;


@end
