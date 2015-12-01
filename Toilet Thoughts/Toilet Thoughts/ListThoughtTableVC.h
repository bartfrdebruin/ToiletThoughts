//
//  ListThoughtTableVC.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 01-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ListThoughtTableVC : UITableViewController

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic) int chosenList;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) NSArray *winningThoughts;


@end
