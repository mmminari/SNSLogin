//
//  ViewController.m
//  SNSLogin
//
//  Created by 김민아 on 2017. 1. 24..
//  Copyright © 2017년 김민아. All rights reserved.
//

#import "ViewController.h"
#import "UserProfileViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    
    self.loginButton.delegate = self;
    
    self.loginButton.readPermissions = @[@"public_profile", @"user_friends"];

}

#pragma mark - User Action

- (IBAction)touchedLoginButton:(UIButton *)sender
{
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Unexpected login error: %@", error);
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else
    {
        NSLog(@"result ; %@", result.grantedPermissions);
        
        [self moveToDetailVC];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
    
}

- (void)moveToDetailVC
{
    UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-UserProfileVC"];
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}



@end
