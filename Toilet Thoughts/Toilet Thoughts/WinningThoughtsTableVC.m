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
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WinningThoughtCustomVideoCell"];
    
    [self performSelector:@selector(retrieveFromParse)];
    
    [self.tableView setAllowsMultipleSelection:YES];
    
    self.title = @"Winning Thoughts";
    
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
    
    return cell;
}

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
//    [self updateTableView];
}




@end
