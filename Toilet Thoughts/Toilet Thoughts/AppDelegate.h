//
//  AppDelegate.h
//  Toilet Thoughts
//
//  Created by Bart de Bruin on 24-11-15.
//  Copyright © 2015 BartandFouad. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *loginDictionary;
//@property (strong, nonatomic) NSString *YouTubeAPIKey;

-(UIColor*)colorWithHexString:(NSString*)hex;

@end



