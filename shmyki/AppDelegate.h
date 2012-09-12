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
#import "SA_OAuthTwitterController.h"  

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate, FBRequestDelegate,SA_OAuthTwitterControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, strong) Facebook *facebook;

@property (nonatomic, strong) SA_OAuthTwitterEngine *twitterEngine; 

@property (nonatomic, strong) PunchOnLog *currentUsersPunchOnLog;

@property (nonatomic) BOOL isFaceBookRequired;

@property (nonatomic) BOOL isTwitterRequired;


-(void)logInToFacebook;
-(void)postToFacebook;

- (UIViewController*) getlogInToTwitterViewController;

-(NSString*) convertLocationToShortLocation: (NSString*)location;
-(void)postToTwitter;

-(void)saveCurrentUsersPunchOnLog;
-(void)clearCurrentUsersPunchOnLog;
@end
