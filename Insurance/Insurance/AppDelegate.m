//
//  AppDelegate.m
//  Insurance
//
//  Created by MonuRathor on 17/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import "AppDelegate.h"
#import <HockeySDK/HockeySDK.h>

@implementation AppDelegate

+(AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //-- Crash Reporting by Hockey App
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"91c14f99ca9d4da889b9f766e95b4963"];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus: BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    //-- Initialize loading view
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.loadingView addSubview:self.indicator];
    self.loadingView.layer.cornerRadius = 10.0f;
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.indicator.center = self.loadingView.center;
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)startLoadingView{
    if (![self.loadingView isDescendantOfView:self.window]) {
        self.window.userInteractionEnabled = NO;
        self.loadingView.center = self.window.center;
        [self.window addSubview:self.loadingView];
        [self.indicator startAnimating];
    }
    
}

- (void)stopLoadingView{
    if ([self.loadingView isDescendantOfView:self.window]) {
        self.window.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
        [self.loadingView removeFromSuperview];
    }
}


- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
