//
//  AppDelegate.m
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"5rjtz2tTE20irUv60ZCDwfNFjHko7ifrT0qvWx76"
                  clientKey:@"mNz0K8ueDslvioTHqGqwXxr7oVXMY31aNTrP0lF5"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    // Override point for customization after application launch.
    
    HomeViewController *homevc = [[HomeViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homevc];
    
    self.window.rootViewController = navigationController;
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.0
                                                               green:0.9921568627
                                                                blue:0.3529411765
                                                               alpha:1.0f]];
    
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.4588235294
                                                                      green:0.1098039216
                                                                       blue:0.2705882353
                                                                      alpha:1.0f];
    
    // To do: change the deprecated classes intro appropiate ones and updated the values.
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:1.0 green:0.9921568627 blue:0.3529411765 alpha:1.0],
                                                          NSForegroundColorAttributeName,
                                                          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                                          UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                          UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica-Bold" size:0.0],
                                                          UITextAttributeFont,
                                                          nil]];


    
    [navigationController setNavigationBarHidden:YES];

    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
