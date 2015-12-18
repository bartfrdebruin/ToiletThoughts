//
//  ListThoughtTableVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 01-12-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "ListThoughtTableVC.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LoginViewController.h"
#import "UserViewController.h"
#import "AddThoughtVC.h"
#import "WinningThoughtCustomVideoCell.h"
#import "SelectedThoughtDetailVC.h"
#import "ThoughtCustomCell.h"
#import "DetailVideoViewController.h"
#import "TAAYouTubeWrapper.h"
#import "GTLYouTube.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ToiletThoughts-Swift.h"
#import <AVFoundation/AVFoundation.h>


@interface ListThoughtTableVC ()

@end

@implementation ListThoughtTableVC



#pragma mark - viewDidload

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *thoughtNib = [UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil];
    [self.tableView registerNib:thoughtNib forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    UINib *winningNib = [UINib nibWithNibName:@"WinningThoughtCustomVideoCell" bundle:nil];
    [self.tableView registerNib:winningNib forCellReuseIdentifier:@"WinningThoughtCustomVideoCell"];
        
    self.chosenList = 1;

    [TAAYouTubeWrapper videosForChannel:@"UCW657Mv0k4cDN7vbg2srPNQ" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        
        if (videos) {
            self.taugeTVPlaylist = videos;
        }
    }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController setToolbarHidden:NO];
    
    // Custom Back button to support custom navigation.
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [backButton setTitle:@"<Back" forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(backToHomeScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE ACTIVE"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    else {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE PASSIVE"] forState:UIControlStateNormal];
        [userLoginButton addTarget:self action:@selector(goToUserScreen) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userLoginButton];
    }
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    UIBarButtonItem *addPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoAddThoughtVC)];
    
    UIBarButtonItem *selectTableView = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(updateTableview)];
    
    self.toolbarItems = [NSArray arrayWithObjects:space, addPostButton, space, selectTableView, nil];
    [self.navigationController setToolbarItems:self.toolbarItems];
    
    [self.tableView reloadData];
}


#pragma mark - navigation

- (void)backToHomeScreen {
    
    // Custom ViewController animation.
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:homeVC animated:NO];
    [UIView commitAnimations];
}

- (void)goToUserScreen {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        UserViewController * userViewController = [[UserViewController alloc] init];
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.navigationController.view cache:NO];
        
        [self.navigationController pushViewController: userViewController animated:YES];
        [UIView commitAnimations];
        
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
        
}

- (void)gotoAddThoughtVC {
    
    AddThoughtVC *atvc = [[AddThoughtVC alloc] init];
    atvc.presentedFromVC = self;
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:atvc animated:YES];
    [UIView commitAnimations];
}


#pragma mark - alert

- (void)updateTableview {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sort Toilet Thoughts"
                                                                   message:@"Choose how you want the Toilet Thoughts to be sorted!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *popularThoughts = [UIAlertAction actionWithTitle:@"Popular Thoughts" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                
                                                                self.chosenList = 1;
                                                                [self retrieveFromParseScore];
                                                            }];
    
    UIAlertAction *recentThoughts = [UIAlertAction actionWithTitle:@"Recent Thoughts" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               self.chosenList = 2;
                                                               [self retrieveFromParseRecent];
                                                           }];
    
    UIAlertAction *winningThoughts = [UIAlertAction actionWithTitle:@"Winning Thoughts" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                
                                                                self.chosenList = 3;
                                                                [self retrieveFromParseWinning];
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


#pragma mark - queries


- (void)retrieveFromParseRecent {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.toiletThoughts = [[NSMutableArray alloc] initWithArray: objects];
            [self.tableView reloadData];
        }
    }];
}


- (void)retrieveFromParseWinning {
        
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    [query whereKeyExists:@"winningYouTubeVideoThoughtID"];
    [query orderByDescending:@"score"];
    
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.winningThoughts = [[NSMutableArray alloc] initWithArray: objects];
            [self.tableView reloadData];
        }
    }];
}


- (void)retrieveFromParseScore {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    [query orderByDescending:@"score"];
    
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.toiletThoughts = [[NSMutableArray alloc] initWithArray: objects];
            [self.tableView reloadData];
        }
    }];
}

- (void)retrieveFromParseAudioFile {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
    
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.toiletThoughts = [[NSArray alloc] initWithArray: objects];
            
//            PFFile *audioThought = self.toiletThoughts[@"audioFile"];
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.chosenList == 3) {
        return self.taugeTVPlaylist.count;
        
    } else {
        return self.toiletThoughts.count;
    }
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    if
        (self.chosenList == 3)
    {
        
        return 180;
        
    } else {
        
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chosenList == 3) {
    

        WinningThoughtCustomVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinningThoughtCustomVideoCell" forIndexPath:indexPath];
        
        GTLYouTubeVideo * currentVideo = [self.taugeTVPlaylist objectAtIndex:indexPath.row];
        GTLYouTubeVideoSnippet *currentVideoSnippet = currentVideo.snippet;
        cell.usernameWinningThoughtCVC.text = currentVideoSnippet.title;
        NSString *currentVideoSnippetURL = currentVideoSnippet.thumbnails.standard.url;
        
        [cell.thumbnailWinningThoughtCVC sd_setImageWithURL:[NSURL URLWithString:currentVideoSnippetURL]];
                                                             
//                                                                    //        cell.thoughtWinningThoughtCVC.text = [currentVideo objectForKey:@"winningText"];
//        cell.scoreWinningThoughtCVC.text = [currentThought objectForKey:@"winningScore"];
//        
//        PFFile *winningImageFile = [currentThought objectForKey:@"winningImage"];
//        PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
//        thumbnail.image = [UIImage imageNamed:@"Icon-40"];
//        thumbnail.file = winningImageFile;
//        [thumbnail loadInBackground];
    
        return cell;
        
    } else {
        
        ThoughtCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell" forIndexPath:indexPath];
        
        PFObject * currentThought = [self.toiletThoughts objectAtIndex:indexPath.row];
        
        cell.usernameThoughtCustomCell.text = [currentThought objectForKey:@"userName"];
        
        cell.thoughtLabel.text = [currentThought objectForKey:@"toiletThought"];
        
        if ([cell.thoughtLabel.text isEqualToString:@""]) {
            
            cell.thoughtLabel.text = @"'This thought was recorded by audio.'";
        }
        NSNumber *score = [currentThought objectForKey:@"score"];
        int scoreInIntValue = [score intValue];
        
        if (scoreInIntValue >= 0) {
            
            cell.thumbsDown.hidden = YES;
            cell.thumbsUp.hidden = NO;
            cell.scoreThoughtCustomCell.text = [NSString stringWithFormat:@" %@", score];

        
        } else if (scoreInIntValue < 0) {
            
            cell.thumbsUp.hidden = YES;
            cell.thumbsDown.hidden = NO;
            cell.scoreThoughtCustomCell.text = [NSString stringWithFormat:@" %@", score];
        }
        
        cell.dateLabel.text = [currentThought objectForKey:@"createdAt"];
        
        PFFile *thoughtImageFile = [currentThought objectForKey:@"thoughtImage"];
        PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
        thumbnail.image = [UIImage imageNamed:@"Icon-40"];
        thumbnail.file = thoughtImageFile;
        [thumbnail loadInBackground];
        
        
        
        return cell;
    }

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chosenList == 1) {
        
        SelectedThoughtDetailVC *stdvc = [[SelectedThoughtDetailVC alloc]init];
        
        PFObject * selectedThought = self.toiletThoughts[indexPath.row];
        
        PFFile *audioThought = [selectedThought objectForKey:@"audioFile"];
        
        stdvc.thoughtImageFile = [selectedThought objectForKey:@"thoughtImage"];
        stdvc.thoughtDetail = [selectedThought objectForKey:@"toiletThought"];
        stdvc.score = [[selectedThought objectForKey:@"score"] integerValue];
        stdvc.currentThought = selectedThought;
        stdvc.audioThought = audioThought;
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.navigationController.view cache:NO];
        
        [self.navigationController pushViewController:stdvc animated:YES];
        [UIView commitAnimations];
        
    } else if (self.chosenList == 2) {
        
        SelectedThoughtDetailVC *stdvc = [[SelectedThoughtDetailVC alloc]init];
        
        PFObject * selectedThought = self.toiletThoughts[indexPath.row];
        
        PFFile *audioThought = [selectedThought objectForKey:@"audioFile"];
        
        stdvc.thoughtImageFile = [selectedThought objectForKey:@"thoughtImage"];
        stdvc.thoughtDetail = [selectedThought objectForKey:@"toiletThought"];
        stdvc.score = [[selectedThought objectForKey:@"score"] integerValue];
        stdvc.currentThought = selectedThought;
        stdvc.audioThought = audioThought;
        
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromLeft
                               forView:self.navigationController.view cache:NO];
        
        [self.navigationController pushViewController:stdvc animated:YES];
        [UIView commitAnimations];
        
        
    } else {
        
        DetailVideoViewController *detailVideoViewController = [[DetailVideoViewController alloc] init];
        GTLYouTubeVideo *selectedVideo = [self.taugeTVPlaylist objectAtIndex:indexPath.row];
        
        PFQuery *query = [PFQuery queryWithClassName:@"ToiletThought"];
        [query whereKey:@"winningYouTubeVideoThoughtID" equalTo:selectedVideo.identifier];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (objects) {
                self.currentVideoObject = objects[0];
                
                detailVideoViewController.currentWinningThought = self.currentVideoObject;
                [self.navigationController pushViewController:detailVideoViewController animated:YES];
            }
        }];
    }
}


@end
