//
//  UserViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 26-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "ThoughtCustomCell.h"
#import "ListThoughtTableVC.h"
#import "SelectedThoughtDetailVC.h"


@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.currentUser = [PFUser currentUser];
    
    self.title = self.currentUser[@"username"];
    
    if (self.currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"person_loggedIn_small"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    [query whereKey:@"userName" equalTo:self.currentUser.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
    self.toiletThoughts = objects;
        [self.tableView reloadData];
        
    }];

    

}

- (void)logOut {
    
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Log out?" message: @"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              HomeViewController *hvc = [[HomeViewController alloc] init];
                                                              [self.navigationController pushViewController:hvc animated:yes];
                                                          
                                                          }];
    [alert addAction:cancel];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:YES completion:nil];

    [PFUser logOut];
}

#pragma mark - tableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}

- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView
                  cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    ThoughtCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell"];
    if (!cell) {
        
        [tableView registerNib: [UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil] forCellReuseIdentifier:@"ThoughtCustomCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell"];
    }
    
    PFObject * currentThought = [self.toiletThoughts objectAtIndex:indexPath.row];
    
    cell.usernameThoughtCustomCell.text = [currentThought objectForKey:@"userName"];
    cell.thoughtLabel.text = [currentThought objectForKey:@"toiletThought"];
    
    NSNumber *score = [currentThought objectForKey:@"score"];
    cell.scoreThoughtCustomCell.text = [NSString stringWithFormat:@" %@", score];
    
    cell.dateLabel.text = [currentThought objectForKey:@"createdAt"];
    
    PFFile *thoughtImageFile = [currentThought objectForKey:@"thoughtImage"];
    PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
    thumbnail.image = [UIImage imageNamed:@"Icon-40"];
    thumbnail.file = thoughtImageFile;
    [thumbnail loadInBackground];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.toiletThoughts.count;
}


- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectedThoughtDetailVC *stdvc = [[SelectedThoughtDetailVC alloc]init];
    
    PFObject * selectedThought = self.toiletThoughts[indexPath.row];
    
    stdvc.thoughtImageFile = [selectedThought objectForKey:@"thoughtImage"];
    stdvc.thoughtDetail = [selectedThought objectForKey:@"toiletThought"];
    stdvc.score = [[selectedThought objectForKey:@"score"] integerValue];
    stdvc.currentThought = selectedThought;
        
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:stdvc animated:YES];
    [UIView commitAnimations];
}







@end
