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

@interface UserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *toiletThoughts;
@property (nonatomic, strong) NSArray *groceries;


@end
