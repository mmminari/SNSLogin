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


@interface ViewController ()// <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
//@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic) NSString *userID;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
//    self.loginButton = [[FBSDKLoginButton alloc] init];
//    
//    self.loginButton.delegate = self;
//    
//    self.loginButton.readPermissions = @[@"public_profile",@"email" ,@"user_friends"];

}

#pragma mark - User Action

- (IBAction)touchedLoginButton:(UIButton *)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    
    NSArray *permissions = @[@"public_profile",@"email" ,@"user_friends", @"user_birthday"];
    
    [login logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        NSLog(@"login result : %@",result);
        
        NSLog(@"login error : %@", error);
        
        NSString *userId = result.token.userID;
        
        self.userID = userId;
        
        if([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"])
        {
            NSLog(@"email granted");
        }
        
        if([result.declinedPermissions containsObject:@"email"])
        {
            NSLog(@"email permission declined");
        }
        
        
        
        [self moveToDetailVC];
        
    }];
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
        
        NSString *userId = result.token.userID;
        
        self.userID = userId;
        
        [self moveToDetailVC];
    }
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"logOut!");
}

- (void)moveToDetailVC
{
    UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-UserProfileVC"];
    
    userProfileVC.userId = self.userID;
//    userProfileVC.request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me/taggable_friends?limit=10"
//                                                             parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"
//                                                                           };
    userProfileVC.profileRequest = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me/public_profile" parameters:nil];
                                                                                                                       
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}



@end
