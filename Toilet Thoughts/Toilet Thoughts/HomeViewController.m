//
//  HomeViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "HomeViewController.h"
#import "PopularThoughtsTableVC.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)browseThoughts:(id)sender {
    
    PopularThoughtsTableVC *popularThoughtsTableVC = [[PopularThoughtsTableVC alloc] initWithNibName:@"PopularThoughtsTableVC" bundle:nil];
    [self.navigationController pushViewController:popularThoughtsTableVC animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (IBAction)addThoughts:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
