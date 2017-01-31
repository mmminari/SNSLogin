//
//  UserProfileViewController.m
//  SNSLogin
//
//  Created by 김민아 on 2017. 1. 25..
//  Copyright © 2017년 김민아. All rights reserved.
//

#import "UserProfileViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Security/Security.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbId;

@property (strong, nonatomic) NSArray *resultList;
@property (strong, nonatomic) FBSDKProfile *profile;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self fetchData];
    
    [self getUserProfile];
    
}

- (void)fetchData
{
    [self.request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(error)
        {
            NSLog(@"error:%@", error.description);
        }
        else
        {
            NSDictionary *resultData = (NSDictionary *)result;
            
            self.resultList = [resultData objectForKey:@"data"];
            
            NSLog(@"self.resultLisg : %@", self.resultList);

        }

    }];
}

- (void)getUserProfile
{
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
        
        self.profile = profile;
        
        NSURL *url = [self.profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(300, 300)];
        
        [self setImageView:self.ivProfile urlString:[NSString stringWithFormat:@"%@",url] placeholderImage:nil animation:YES];
        
        NSString *userName = self.profile.name;
        
        self.lbUserName.text = userName;
        
        [self.view layoutIfNeeded];
        
        
    }];
    
    NSString *path = [NSString stringWithFormat:@"/%@", self.userId];
    
    NSLog(@"path : %@", path);
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:path
                                  parameters:parameters
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSLog(@"UserProfile request result : %@", result);
        
        
        NSDictionary *resultData = (NSDictionary *)result;
        
        
        NSLog(@"error : %@", error.description);
        
        self.lbId.text = [resultData objectForKey:@"id"];
        self.lbEmail.text = [resultData objectForKey:@"email"];
        
    }];
}

- (IBAction)touchedLogOutButton:(UIButton *)sender
{
    
//    [self deleteCache];
//    
//    [FBSDKAccessToken setCurrentAccessToken:nil];
//    
//    
//    
//    [FBSDKLoginManager renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
//        
//        NSLog(@"result ; %zd", result);
//        
//        NSLog(@"error : %@", error.description);
//        
//    }];
//    
//
//    
//    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    
//    NSLog(@"cookies : %@", cookies);
//    
//    for(NSHTTPCookie *cookie in [cookies cookies]) {
//        
//        NSLog(@"cookie : %@", cookie.domain);
//        
//        
//        if([[cookie domain] isEqualToString:@"facebook"]) {
//            
//            NSLog(@"domain : %@", cookie.domain);
//            
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
//    
    NSString *path = @"me/permissions/";
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:path
                                  parameters:nil
                                  HTTPMethod:@"DELETE"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        if ([FBSDKAccessToken currentAccessToken]) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }
        

        NSLog(@"result : %@", result);
        
        NSLog(@"error : %@", error.description);
        
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }];

    
}


#pragma mark - Private Method

-(void)setImageView:(UIImageView *)imageView urlString:(NSString *)urlString placeholderImage:(UIImage *)image animation:(BOOL)ani
{
    NSURL *url = [NSURL URLWithString:urlString];
    [imageView sd_setImageWithURL:url placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if(cacheType == SDImageCacheTypeNone)
         {
             if(ani)
             {

                 [imageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:@"fadeOutAnimationForChangeImage"];
             }
             
         }
     }];
}



- (CATransition *)fadeOutAnimationForChangeImage
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    return transition;
}

- (void)deleteCache
{
    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecClassInternetPassword,
                                (__bridge id)kSecClassCertificate,
                                (__bridge id)kSecClassKey,
                                (__bridge id)kSecClassIdentity];
    for (id secItemClass in secItemClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
    
    NSLog(@"delete done");
}



@end
