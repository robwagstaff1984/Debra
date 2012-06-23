//
//  MykiBalanceViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MykiAccountInformation.h"
#import "MBProgressHUD.h"

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate>


@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL userIsLoggedIn;
@property (nonatomic) BOOL errorLoadingBalance;
@property (nonatomic, strong) MykiAccountInformation *mykiAccountInformation;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UITableView *loginTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIScrollView *pageScrollView;
@property (nonatomic, strong) IBOutlet UIView *balanceDisplayView;

@property (nonatomic, strong) IBOutlet UILabel* balanceHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel* balanceMykiPassExpiryLabel;
@property (nonatomic, strong) IBOutlet UILabel* balanceMykiPassAdditionalLabel;
@property (nonatomic, strong) IBOutlet UILabel* balanceMykiMoneyAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel* balanceMykiMoneyAdditionalLabel;
@property (nonatomic, strong) IBOutlet UILabel* balanceFooterLabelOne;
@property (nonatomic, strong) IBOutlet UILabel* balanceFooterLabelTwo;

@property (nonatomic, strong) MBProgressHUD *HUD;

-(void)retrieveMykiBalance;
- (void)webViewDidFinishLoad:(UIWebView *)webView;

@end
