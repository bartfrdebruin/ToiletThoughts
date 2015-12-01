//
//  PopularThoughtsTableVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface PopularThoughtsTableVC : UITableViewController

@property (nonatomic, strong) UIView *floatingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *popular;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic) int chosenList;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) NSArray *winningThoughts;



//@property (strong, nonatomic) PFFile *thoughtImageFile;




@end
