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
        
        
        // email에 대한 권한을 받았는지 체크
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

#pragma mark - Private Method

- (void)moveToDetailVC
{
    UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-UserProfileVC"];
    
    userProfileVC.userId = self.userID;
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

// 기존 Facebook에서 제공하는 로그인 버튼을 이용했을 때 사용하는 부분
// 현재는 사용 X
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




@end
