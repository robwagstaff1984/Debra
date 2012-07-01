//
//  AppDelegate.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "PunchOnLog.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate, FBRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, strong) Facebook *facebook;

@property (nonatomic, strong) PunchOnLog *currentUsersPunchOnLog;

-(void)logInToFacebook;
-(void)postToFacebook;
@end
