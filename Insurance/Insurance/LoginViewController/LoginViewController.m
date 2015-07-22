//
//  LoginViewController.m
//  Insurance
//
//  Created by MonuRathor on 18/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestConnection.h"

@interface LoginViewController ()<RequestConnectionDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginBox;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-- setup border of register fields
    self.loginBox.layer.masksToBounds = YES;
    self.loginBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginBox.layer.borderWidth = 1.0f;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"KeepMeLoggedIn"]) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
    
    self.btnKeepMe.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.txtEmail isEqual:textField]) {
        [self.txtPassword becomeFirstResponder];
    }
    else if([self.txtPassword isEqual:textField]){
        [self.txtPassword resignFirstResponder];
    }
    return YES;
}

- (IBAction)clickedLogin:(id)sender {
    [[AppDelegate sharedAppDelegate] startLoadingView];
    RequestConnection *connection = [[RequestConnection alloc] init];
    connection.delegate = self;
    [connection loginUser:self.txtEmail.text Password:self.txtPassword.text];
}

- (IBAction)clickedKeepMeLoggedIn:(id)sender {
    UIButton *btnTemp = (UIButton *)sender;
    if (btnTemp.selected) {
        btnTemp.selected = NO;
    }
    else{
        btnTemp.selected = YES;
    }
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        if ([[response valueForKeyPath:@"status"] boolValue] == YES) {
            [[NSUserDefaults standardUserDefaults] setBool:self.btnKeepMe.selected forKey:@"KeepMeLoggedIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"login_success" sender:self];
        }
        else{
            [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:[response valueForKey:@"message"]];
        }

    }
    else{
        [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:error.localizedDescription];
    }
}

@end
