//
//  MykiBalanceViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *mykiUsername; 
@property (nonatomic, strong) NSString *mykiPassword;
@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL userIsLoggedIn;

@end
