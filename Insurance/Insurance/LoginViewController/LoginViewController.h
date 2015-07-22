//
//  LoginViewController.h
//  Insurance
//
//  Created by MonuRathor on 18/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnKeepMe;

- (IBAction)clickedLogin:(id)sender;
- (IBAction)clickedKeepMeLoggedIn:(id)sender;
@end
