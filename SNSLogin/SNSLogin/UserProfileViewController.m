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

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserProfile];
    
    [self getAdditionalUserInfo];
    
}

- (void)getUserProfile
{
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
        
        NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(300, 300)];
        
        [self setImageView:self.ivProfile urlString:[NSString stringWithFormat:@"%@",url] placeholderImage:nil animation:YES];
        
        NSString *userName = profile.name;
        
        self.lbUserName.text = userName;
        
        [self.view layoutIfNeeded];
        
    }];
}

- (void)getAdditionalUserInfo
{
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
        
        NSDictionary *resultData = (NSDictionary *)result;
        
        NSLog(@"UserProfile request result : %@", resultData);

        NSLog(@"error : %@", error.description);
        
        self.lbId.text = [resultData objectForKey:@"id"];
        self.lbEmail.text = [resultData objectForKey:@"email"];
        
    }];
}

- (IBAction)touchedLogOutButton:(UIButton *)sender
{

    // 기존에 요청했던 권한들 제거
    NSString *path = @"me/permissions/";
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:path
                                  parameters:nil
                                  HTTPMethod:@"DELETE"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        // 제거 후 토큰값과 프로필 정보 제거
        if ([FBSDKAccessToken currentAccessToken])
        {
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }

        NSLog(@"result : %@", result);
        
        NSLog(@"error : %@", error);
        
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

@end
