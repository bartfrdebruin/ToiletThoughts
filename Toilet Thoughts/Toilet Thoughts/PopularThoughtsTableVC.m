//
//  PopularThoughtsTableVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "PopularThoughtsTableVC.h"
#import "AddThoughtVC.h"
#import "WinningThoughtsTableVC.h"
#import "SelectedThoughtDetailVC.h"
#import "ThoughtCustomCell.h"
#import <Parse/Parse.h>

@interface PopularThoughtsTableVC ()

@property (nonatomic, strong) NSArray *toiletThoughts;

@end

@implementation PopularThoughtsTableVC

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

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    UINib *nib = [UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    [self performSelector:@selector(retrieveFromParse)];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    
//    UITabBarController *tabBar = [[UITabBarController alloc]init];
//    NSArray *viewControllers = [[NSArray alloc]init];
//    
//    AddThoughtVC *addThoughtVC = [[AddThoughtVC alloc]init];
//    WinningThoughtsTableVC *winningThoughtsTVC = [[WinningThoughtsTableVC alloc]init];
//    
//    addThoughtVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Add" image:nil tag:1];
//    winningThoughtsTVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Winners" image:nil tag:2];
//    
//    tabBar.viewControllers = viewControllers;
    
    
    
//    self.navigationController.toolbarHidden = NO;
    
    
//    self.navigationController.toolbarItems = @[Item1, Item2];
    
    
    
    self.title = @"Popular";
}

- (void) retrieveFromParse {
    
    PFQuery *retrieveThoughts = [PFQuery queryWithClassName:@"ToiletThought"];
    
    [retrieveThoughts findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            self.toiletThoughts = [[NSArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.toiletThoughts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThoughtCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell" forIndexPath:indexPath];
//    [tableView registerNib:[[UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil] forCellReuseIdentifier:@"ThoughtCustomCell"];
    // Configure the cell...
//    cell.textLabel.text = @"We are the best and Enrico sucks!";
    
    PFObject * thoughtsDict = [self.toiletThoughts objectAtIndex:indexPath.row];
    

    cell.usernameThoughtCustomCell.text = [thoughtsDict objectForKey:@"userName"];
//    cell.thoughtImageThumbnail.image = [thoughtsDict objectForKey:@"thoughtImage"];
    cell.thoughtLabel.text = [thoughtsDict objectForKey:@"toiletThought"];
    cell.scoreThoughtCustomCell.text = [thoughtsDict objectForKey:@"score"];
    
    PFFile *thoughtImageFile = [thoughtsDict objectForKey:@"thoughtImage"];
    PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
    thumbnail.image = [UIImage imageNamed:@"Icon-40"];
    thumbnail.file = thoughtImageFile;
    [thumbnail loadInBackground];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
    
    // Push the view controller.
//    [self.navigationController pushViewController:stdvc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
