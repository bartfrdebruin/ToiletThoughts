//
//  PopularThoughtsTableVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PopularThoughtsTableVC.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "AddThoughtVC.h"
#import "WinningThoughtsTableVC.h"
#import "SelectedThoughtDetailVC.h"
#import "ThoughtCustomCell.h"
#import "HomeViewController.h"


@interface PopularThoughtsTableVC ()

//@property (nonatomic, strong) NSArray *toiletThoughts;

@end

@implementation PopularThoughtsTableVC


#pragma mark - goToWinning Thoughts

- (IBAction)popular:(id)sender {
    
    WinningThoughtsTableVC *winningTTVC = [[WinningThoughtsTableVC alloc]initWithNibName:@"WinningThoughtsTableVC" bundle:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:winningTTVC animated:YES];
    [UIView commitAnimations];
    
}

#pragma mark - backToHome and goToUserScreen

- (void)backToHomeScreen {
    
    HomeViewController *homeScreenVC = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeScreenVC animated:YES];
    
}

- (void)goToUserScreen {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        UserViewController * userViewController = [[UserViewController alloc] init];
        [self.navigationController pushViewController: userViewController animated:YES];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}


#pragma mark - viewDidLoad

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController setToolbarHidden:NO];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setImage:[UIImage imageNamed:@"home_yellow_small.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToHomeScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"person_loggedIn_small"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    else {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"person_small.png"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    UIBarButtonItem *addPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoAddThoughtVC)];
    
    UIBarButtonItem *selectTableView = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(updateTableview)];
    
    
    self.toolbarItems = [NSArray arrayWithObjects:space, addPostButton, space, selectTableView, nil];
    [self.navigationController setToolbarItems:self.toolbarItems];
    
}


- (void)gotoAddThoughtVC {
    
    AddThoughtVC *atvc = [[AddThoughtVC alloc] init];
    [self.navigationController pushViewController:atvc animated:YES];
}


- (void)updateTableview {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sort Toilet Thoughts"
                                                                   message:@"Choose how you want the Toilet Thoughts to be sorted!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *popularThoughts = [UIAlertAction actionWithTitle:@"Popular Thoughts" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                            
                                                              self.chosenList = 1;
                                                              [self retrieveFromParse];
                                                            }];
    
    UIAlertAction *recentThoughts = [UIAlertAction actionWithTitle:@"Recent Thoughts" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               self.chosenList = 2;
                                                               [self retrieveFromParse];

                                                           }];
    
    UIAlertAction *winningThoughts = [UIAlertAction actionWithTitle:@"Winning Thoughts" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                            
                                                          
                                                          }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * action) {
                                                                
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                                
                                                            }];
    [alert addAction:popularThoughts];
    [alert addAction:recentThoughts];
    [alert addAction:winningThoughts];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:NO completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    [self performSelector:@selector(retrieveFromParse)];
    
    self.title = @"Popular";
}


- (void)retrieveFromParse {
    
    
    if (self.chosenList == 1) {
        
        PFQuery *queryForPopularToiletThougts = [PFQuery queryWithClassName:@"ToiletThought"];
        [queryForPopularToiletThougts orderByAscending:@"score"];
        
        [queryForPopularToiletThougts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                self.toiletThoughts = [[NSArray alloc] initWithArray:objects];
                [self.tableView reloadData];
                
            }
        }];
    } else if (self.chosenList == 2) {
        
        PFQuery *queryForRecentToiletThougts = [PFQuery queryWithClassName:@"ToiletThought"];
        [queryForRecentToiletThougts orderByDescending:@"createdAt"];
        
        [queryForRecentToiletThougts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                self.toiletThoughts = [[NSArray alloc] initWithArray:objects];
                [self.tableView reloadData];
                
                
            }
        }];
        
    } else {
        
        PFQuery *standardQuery = [PFQuery queryWithClassName:@"ToiletThought"];
        [standardQuery orderByAscending:@"score"];
        
        [standardQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                self.toiletThoughts = [[NSArray alloc] initWithArray:objects];
                [self.tableView reloadData];
                
                
            }
        }];
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.toiletThoughts.count;
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThoughtCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell" forIndexPath:indexPath];
    
    PFObject * thoughtsDict = [self.toiletThoughts objectAtIndex:indexPath.row];
    

    cell.usernameThoughtCustomCell.text = [thoughtsDict objectForKey:@"userName"];
    cell.thoughtLabel.text = [thoughtsDict objectForKey:@"toiletThought"];
    cell.scoreThoughtCustomCell.text = [thoughtsDict objectForKey:@"score"];
    cell.dateLabel.text = [thoughtsDict objectForKey:@"createdAt"];
    
    PFFile *thoughtImageFile = [thoughtsDict objectForKey:@"thoughtImage"];
    PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
    thumbnail.image = [UIImage imageNamed:@"Icon-40"];
    thumbnail.file = thoughtImageFile;
    [thumbnail loadInBackground];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SelectedThoughtDetailVC *stdvc = [[SelectedThoughtDetailVC alloc]init];
    
    PFObject * thoughtsDict = [self.toiletThoughts objectAtIndex:indexPath.row];
    
    stdvc.thoughtImageFile = [thoughtsDict objectForKey:@"thoughtImage"];
    stdvc.thoughtDetail = [thoughtsDict objectForKey:@"toiletThought"];
    stdvc.thoughtScore = [thoughtsDict objectForKey:@"score"];
    
    // Pass the selected object to the new view controller.
    
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
