//
//  MykiBalanceViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MykiAccountInformation.h"

@interface MykiBalanceViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *mykiUsername; 
@property (nonatomic, strong) NSString *mykiPassword;
@property (nonatomic, strong) NSString *mykiLoginUrl;
@property (nonatomic, strong) UIWebView *mykiWebstiteWebView;
@property (nonatomic) BOOL userIsLoggedIn;
@property (nonatomic, strong) MykiAccountInformation *mykiAccountInformation;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UITableView *loginTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

/*@property (nonatomic, strong) IBOutlet UILabel* cardHolderLabel;
@property (nonatomic, strong) IBOutlet UILabel* cardTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel* cardExpiryLabel;
@property (nonatomic, strong) IBOutlet UILabel* cardStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel* currentMykiMoneyBalanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* mykiMoneyTopUpInProgressLabel;
@property (nonatomic, strong) IBOutlet UILabel* totalMykiMoneyBalanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* currentMykiPassActiveLabel;
@property (nonatomic, strong) IBOutlet UILabel* currentMykiPassNotYetActiveLabel;
@property (nonatomic, strong) IBOutlet UILabel* lastMykiTransactionDateLabel;
*/


@end
