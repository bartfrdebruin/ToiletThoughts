//
//  WinningThoughtsTableVC.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "WinningThoughtsTableVC.h"
#import "WinningThoughtCustomVideoCell.h"
#import <Parse/Parse.h>

static CGFloat expandedHeight = 100.0;
static CGFloat contractedHeight = 44.0;

@interface WinningThoughtsTableVC ()

@property (nonatomic, strong) NSArray *winningThoughts;

@end

@implementation WinningThoughtsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"WinningThoughtCustomVideoCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"WinningThoughtCustomVideoCell"];
    
    [self performSelector:@selector(retrieveFromParse)];
//    [self performSelector:@selector(myMethod)];
    
    [self.tableView setAllowsMultipleSelection:YES];
    
//    self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Winners" image:nil tag:2];
    
//    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WinningThoughtCustomVideoCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.title = @"Winning";
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) retrieveFromParse {
    
    PFQuery *retrieveThoughts = [PFQuery queryWithClassName:@"WinningThought"];
    
    [retrieveThoughts findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            self.winningThoughts = [[NSArray alloc]initWithArray:objects];
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

    return self.winningThoughts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WinningThoughtCustomVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinningThoughtCustomVideoCell" forIndexPath:indexPath];
    
     PFObject * thoughtsDict = [self.winningThoughts objectAtIndex:indexPath.row];
    
    cell.usernameWinningThoughtCVC.text = [thoughtsDict objectForKey:@"winningUser"];
    cell.thoughtWinningThoughtCVC.text = [thoughtsDict objectForKey:@"winningText"];
    cell.scoreWinningThoughtCVC.text = [thoughtsDict objectForKey:@"winningScore"];
    
    PFFile *winningImageFile = [thoughtsDict objectForKey:@"winningImage"];
    PFImageView *thumbnail = (PFImageView *)[cell viewWithTag:100];
    thumbnail.image = [UIImage imageNamed:@"Icon-40"];
    thumbnail.file = winningImageFile;
    [thumbnail loadInBackground];
    
    // Configure the cell...
    
//    cell.textLabel.text = @"test";
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView indexPathsForSelectedRows].count) {
        
        if ([[tableView indexPathsForSelectedRows] indexOfObject:indexPath] != NSNotFound) {
            return expandedHeight; // Expanded height
        }
        
        return contractedHeight; // Normal height
    }
    
    return contractedHeight; // Normal height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateTableView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateTableView];
}

- (void)updateTableView
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)myMethod {
    
    PFQuery *signUpUser = [[PFQuery alloc]initWithClassName:@"User"];
    
    [signUpUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error) {
            self.winningThoughts = [[NSArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }
        
    }];
    
    PFUser *user = [PFUser user];
    user.username = @"my name";
    user.password = @"my pass";
    user.email = @"email@example.com";
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
        }
    }];
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
