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
#import "MHPagingScrollView.h"
#import "PageControl.h"

@class DateDisplayHelper;
@class Reachability;

typedef enum {
    topUpTypeUnknown = 1,
    topUpTypeMykiMoney = 2,
    topUpTypeMykiPass = 3
} topUpType;

typedef enum {
    topUpPageUnknown = 1,
    topUpPageChooseTopUp = 2,
    topUpPageSpecifyTopUp = 3,
    topUpPageReviewTopUp = 4,
    topUpPagePostReviewTopUp = 5
} topUpPage;

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate, MHPagingScrollViewDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) IBOutlet UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL isUserLoginAttempted;
@property (nonatomic) BOOL isProblemWithMykiCredentials;
@property (nonatomic, strong) MykiAccountInformation *mykiAccountInformation;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIView *errorView;
@property (nonatomic, strong) IBOutlet UIView *toppingUpView;
@property (nonatomic, strong) IBOutlet UITableView *loginTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *mykiMoneyTextField;
@property (nonatomic, strong) UITextField *mykiMoneyTextFieldContainer;
@property (nonatomic, strong) UITextField *mykiPassDaysTextField;
@property (nonatomic, strong) UITextField *mykiPassDaysTextFieldContainer;
@property (nonatomic, strong) UITextField *mykiPassZoneFromTextField;
@property (nonatomic, strong) UITextField *mykiPassZoneToTextField;

@property (nonatomic, strong) IBOutlet UIScrollView *pageScrollView;

@property (nonatomic, strong) IBOutlet UILabel* balanceHeaderLabelOne;
@property (nonatomic, strong) IBOutlet UILabel* balanceHeaderLabelTwo;
@property (nonatomic, strong) IBOutlet UILabel* balanceFooterLabelOne;
@property (nonatomic, strong) IBOutlet UILabel* balanceFooterLabelTwo;

@property (nonatomic, strong) IBOutlet UILabel *errorTextLabel;
@property (nonatomic, strong) IBOutlet UITextView *errorTextView;

@property (nonatomic, strong) IBOutlet UIButton* refreshButton;
@property (nonatomic, strong) IBOutlet UILabel* invalidCredentialsLabel;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInternetDown;
@property (nonatomic) BOOL isRequestingMoreCardData;
@property (nonatomic) BOOL isRequestingNumberOfCards;
@property (nonatomic) BOOL isActiveState;
@property (nonatomic, strong) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, strong) PageControl *pageControl;
@property (nonatomic) int numPages;
@property (nonatomic) int currentlyRequestedCard;

@property (nonatomic) topUpType topUpType;
@property (nonatomic) topUpPage topUpPage;
@property (nonatomic) BOOL isRequestingTopUp;
@property (nonatomic, strong) IBOutlet UIButton* topUpMoneyButton;
@property (nonatomic, strong) IBOutlet UIButton* topUpPassButton;

@property (nonatomic, strong) DateDisplayHelper *dateDisplayHelper;

-(void)retrieveMykiBalance;
-(void) retryRetrieveMykiBalance;
-(void) stopRequest;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
-(IBAction)tryAgainButtonTapped:(id)sender;
-(IBAction)topUpButtonTapped:(id)sender;
-(IBAction) topUpMoneyButtonTapped:(id)sender;
-(IBAction) topUpPassButtonTapped:(id)sender;
@end
