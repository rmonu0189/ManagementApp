//
//  AppDelegate.h
//  Insurance
//
//  Created by MonuRathor on 17/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

+(AppDelegate *)sharedAppDelegate;
- (void)startLoadingView;
- (void)stopLoadingView;
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;

@end
