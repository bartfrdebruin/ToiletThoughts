//
//  HomeViewController.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "HomeViewController.h"
#import "ListThoughtTableVC.h"
#import "AddThoughtVC.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


- (IBAction)browseThoughts:(id)sender {
    
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

- (IBAction)addThoughts:(id)sender {
    
//    self.logIn.hidden = NO;
//    self.signIn.hidden = NO;
    
    AddThoughtVC *addThoughtVC = [[AddThoughtVC alloc] initWithNibName:@"AddThoughtVC" bundle:nil];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    
//    [self.navigationController presentViewController:addThoughtVC animated:YES completion:nil];
        [self.navigationController pushViewController:addThoughtVC animated:YES];

    
     [UIView commitAnimations];
    
    [self.navigationController setNavigationBarHidden:NO];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [self colorWithHexString:@"CF007E"];
    
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // No toolbar
    [self.navigationController setToolbarHidden:YES];

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
