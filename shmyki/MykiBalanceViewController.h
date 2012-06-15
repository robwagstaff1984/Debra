//
//  MykiBalanceViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MykiAccountInformation.h"

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *mykiUsername; 
@property (nonatomic, strong) NSString *mykiPassword;
@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL userIsLoggedIn;
@property (nonatomic, strong) MykiAccountInformation *mykiAccountInformation;

@property (nonatomic, strong) IBOutlet UILabel *label1;


@end
