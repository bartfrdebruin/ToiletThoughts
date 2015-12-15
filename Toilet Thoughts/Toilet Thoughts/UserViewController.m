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
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ThoughtCustomCell.h"
#import "ListThoughtTableVC.h"
#import "SelectedThoughtDetailVC.h"
#import "AddThoughtVC.h"


@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *totalScore;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImage.layer.cornerRadius = self.userImage.bounds.size.width/ 2;
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth = 2;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden =YES;
    
    // Makes the NavigationBar transparent
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    self.currentUser = [PFUser currentUser];
    
    self.title = self.currentUser[@"username"];
    self.userName.text = self.currentUser[@"username"];
    PFFile *userFile = self.currentUser[@"userImage"];
    
    self.userImage.file = userFile;
    [self.userImage loadInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TotalScore"];
    [query whereKey:@"userName" equalTo:self.currentUser[@"username"]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        if (object) {
        
            NSNumber *score = object[@"totalScore"];
            self.totalScore.text = [NSString stringWithFormat:@" %@", score];
        }
       }];
    
  

    [self.tableView setContentInset:UIEdgeInsetsMake(- 65, 0, 0, 0)];
    
    if (self.currentUser) {
        
        UIButton *userLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [userLoginButton setImage:[UIImage imageNamed:@"profile WHITE ACTIVE"] forState:UIControlStateNormal];
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
- (IBAction)logOut:(id)sender {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: @"Log out?" message: @"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];                                                          }];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    
                                                    HomeViewController *hvc = [[HomeViewController alloc] init];
                                                    
                                                    [UIView beginAnimations:@"View Flip" context:nil];
                                                    [UIView setAnimationDuration:0.80];
                                                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                                    
                                                    [UIView setAnimationTransition:
                                                     UIViewAnimationTransitionFlipFromLeft
                                                                           forView:self.navigationController.view cache:NO];
                                                    
                                                    [UIView commitAnimations];
                                                    [self.navigationController pushViewController:hvc animated:YES];
                                                    
                                                }];
    [alert addAction:cancel];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [PFUser logOut];
}


#pragma mark - userImagePicker


- (IBAction)takeAUserPicture:(id)sender {
    
    if (self.userImage.file == nil) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        
        // If the device has a camera, take a picture, otherwise,
        // just pick from photo library
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
        
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.delegate = self;
        
        // Place image picker on the screen
        [self presentViewController:self.imagePicker animated:YES completion: NULL];
    }
}
- (IBAction)addThought:(id)sender {
    
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
- (IBAction)goToList:(id)sender {
    
    ListThoughtTableVC *listThoughtTableVC= [[ListThoughtTableVC alloc] initWithNibName:@"ListThoughtTableVC" bundle:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:listThoughtTableVC animated:YES];
    [UIView commitAnimations];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [listThoughtTableVC retrieveFromParseScore];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.userImage.image = image;
    
    if (self.userImage.image != nil) {
        
        // Toilet Thought User Image
        NSData *imageData = UIImageJPEGRepresentation(self.userImage.image, 0.4);
        
        // User image name
        NSUUID *uuid = [NSUUID UUID];
        
        PFFile *parseUserImage = [PFFile fileWithName:uuid.UUIDString data:imageData];
        
        PFUser *user = [PFUser currentUser];
        [user setObject:parseUserImage forKey:@"userImage"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                NSLog(@"Succes");
            }
            
        }];
    } else if (self.userImage.image == nil) {
        
        self.userImage.image = [UIImage imageNamed:@"Icon-40"];
    }
    
    self.userImage.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

        return @"Your Toilet Thoughts:";
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
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:stdvc animated:YES];
    [UIView commitAnimations];
}


@end
