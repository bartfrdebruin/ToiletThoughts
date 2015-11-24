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

@interface PopularThoughtsTableVC ()

@end

@implementation PopularThoughtsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    UINib *nib = [UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"ThoughtCustomCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    NSArray *viewControllers = [[NSArray alloc]init];
    
    AddThoughtVC *addThoughtVC = [[AddThoughtVC alloc]init];
    WinningThoughtsTableVC *winningThoughtsTVC = [[WinningThoughtsTableVC alloc]init];
    
    addThoughtVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Add" image:nil tag:1];
    winningThoughtsTVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Winners" image:nil tag:2];
    
    tabBar.viewControllers = viewControllers;
    
    
    
    self.title = @"Popular Thoughts";
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

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThoughtCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThoughtCustomCell" forIndexPath:indexPath];
//    [tableView registerNib:[[UINib nibWithNibName:@"ThoughtCustomCell" bundle:nil] forCellReuseIdentifier:@"ThoughtCustomCell"];
    // Configure the cell...
//    cell.textLabel.text = @"We are the best and Enrico sucks!";
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    SelectedThoughtDetailVC *stdvc = [[SelectedThoughtDetailVC alloc]init];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:stdvc animated:YES];
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
