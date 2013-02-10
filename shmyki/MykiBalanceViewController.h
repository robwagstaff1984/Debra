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
@class DateDisplayHelper;
@class Reachability;

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate, MHPagingScrollViewDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) IBOutlet UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL isUserLoginAttempted;
@property (nonatomic) BOOL isProblemWithMykiCredentials;
@property (nonatomic, strong) MykiAccountInformation *mykiAccountInformation;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIView *errorView;
@property (nonatomic, strong) IBOutlet UITableView *loginTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIScrollView *pageScrollView;

@property (nonatomic, strong) UILabel* balanceFooterLabelOne;
@property (nonatomic, strong) UILabel* balanceFooterLabelTwo;
@property (nonatomic, strong) UILabel* balanceHeaderLabel;

@property (nonatomic, strong) IBOutlet UILabel *errorTextLabel;
@property (nonatomic, strong) IBOutlet UITextView *errorTextView;

@property (nonatomic, strong) IBOutlet UIButton* refreshButton;
@property (nonatomic, strong) IBOutlet UILabel* invalidCredentialsLabel;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInternetDown;
@property (nonatomic) BOOL isRequestingSecondCard;
@property (nonatomic, strong) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic) int numPages;

- (IBAction)pageTurn;

@property (nonatomic, strong) DateDisplayHelper *dateDisplayHelper;


-(void)retrieveMykiBalance;
-(void) retryRetrieveMykiBalance;
-(void) stopRequest;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
-(IBAction)tryAgainButtonTapped:(id)sender;

@end
