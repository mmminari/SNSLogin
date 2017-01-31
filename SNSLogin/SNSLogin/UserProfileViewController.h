//
//  UserProfileViewController.h
//  SNSLogin
//
//  Created by 김민아 on 2017. 1. 25..
//  Copyright © 2017년 김민아. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) FBSDKGraphRequest *request;
@property (nonatomic, strong) FBSDKGraphRequest *profileRequest;
@property (nonatomic, strong) NSString *userId;



@end
