//
//  ThoughtCustomCell.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "ThoughtCustomCell.h"

@implementation ThoughtCustomCell

- (void)awakeFromNib {
    // Initialization code
    if (self.scoreThoughtCustomCell <= 0) {
        
        self.scoreThoughtCustomCell.textColor = [UIColor redColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
