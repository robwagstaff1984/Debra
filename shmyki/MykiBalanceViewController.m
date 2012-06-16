//
//  MykiBalanceViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "MykiBalanceViewController.h"
#import "ShmykiContstants.h"
#import <QuartzCore/QuartzCore.h>

@implementation MykiBalanceViewController

@synthesize mykiPassword, mykiUsername, mykiLoginUrl, mykiWebstiteWebView, userIsLoggedIn, mykiAccountInformation;
@synthesize bottomView;
/*@synthesize cardHolderLabel, cardTypeLabel, cardExpiryLabel, cardStatusLabel, currentMykiMoneyBalanceLabel, mykiMoneyTopUpInProgressLabel, totalMykiMoneyBalanceLabel, currentMykiPassActiveLabel, currentMykiPassNotYetActiveLabel, lastMykiTransactionDateLabel;*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mykiUsername = @"rwagstaff84";
        mykiPassword = @"rob11ert";
        mykiLoginUrl = MYKI_LOGIN_URL;
        mykiWebstiteWebView = [[UIWebView alloc] init];
        mykiWebstiteWebView.delegate = self;
        userIsLoggedIn = NO;
        mykiAccountInformation = [[MykiAccountInformation alloc] init];
        [self setTitle:@"Balances"];
        [[self navigationItem] setTitle:@"Balances"];
        
        //[self.bottomView addSubview:myView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl]];
    [mykiWebstiteWebView loadRequest:requestObj];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = bottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [myView.layer insertSublayer:gradient atIndex:0];
    self.view = myView;
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(userIsLoggedIn) {
 
        NSString *fullURL = MYKI_ACCOUNT_INFO_URL;
        NSURL *url = [NSURL URLWithString:fullURL];  
        NSError *error;
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
        [self extractMykiAccountInfoFromHtml:page];
        [self showMykiAccountIformation];
    } else {
        NSString *populateUserNameJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_USERNAME, mykiUsername];
        NSString *populatePasswordJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_PASSWORD, mykiPassword];
        NSString *submitMykiLoginField = JAVASCRIPT_CLICK_SUBMIT; 
        
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populateUserNameJavascript];
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populatePasswordJavascript];
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:submitMykiLoginField]; 

        userIsLoggedIn = YES;        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) extractMykiAccountInfoFromHtml:(NSString*) page {


    [mykiAccountInformation setCardHolder:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_HOLDER]];
    [mykiAccountInformation setCardType:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_TYPE]];
    [mykiAccountInformation setCardExpiry:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_EXPIRY]];
    [mykiAccountInformation setCardStatus:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_STATUS]];
    [mykiAccountInformation setCurrentMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_MONEY_BALANCE]];
    [mykiAccountInformation setMykiMoneyTopUpInProgress:[self extractInformationFromHtml:page withRegeEx:REG_EX_MYKI_MONEY_TOP_UP_IN_PROGRESS]];
    [mykiAccountInformation setTotalMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_TOTAL_MYKI_MONEY_BALANCE]];
    [mykiAccountInformation setCurrentMykiPassActive:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE]];
    [mykiAccountInformation setCurrentMykiPassNotYetActive:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_NOT_YET_ACTIVE]];
    [mykiAccountInformation setLastMykiTransactionDate:[self extractInformationFromHtml:page withRegeEx:REG_EX_LAST_MYKI_TRANSACTION_DATE]];
}

-(void) showMykiAccountIformation {
   /* [cardHolderLabel setText:[mykiAccountInformation cardHolder]];
    [cardTypeLabel setText:[mykiAccountInformation cardType]];
    [cardExpiryLabel setText:[mykiAccountInformation cardExpiry]];
    [cardStatusLabel setText:[mykiAccountInformation cardStatus]];
    [currentMykiMoneyBalanceLabel setText:[mykiAccountInformation currentMykiMoneyBalance]];
    [mykiMoneyTopUpInProgressLabel setText:[mykiAccountInformation mykiMoneyTopUpInProgress]];
    [totalMykiMoneyBalanceLabel setText:[mykiAccountInformation totalMykiMoneyBalance]];
    [currentMykiPassActiveLabel setText:[mykiAccountInformation currentMykiPassActive]];
    [currentMykiPassNotYetActiveLabel setText:[mykiAccountInformation currentMykiPassNotYetActive]];
    [lastMykiTransactionDateLabel setText:[mykiAccountInformation lastMykiTransactionDate]];*/
}

-(NSString*) extractInformationFromHtml:(NSString*) page withRegeEx: (NSString*) regExString {
    NSError *error;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regExString options:0 error:&error];
    NSTextCheckingResult *result = [regEx firstMatchInString:page options:0 range:NSMakeRange(0, [page length])];
    return [page substringWithRange:[result rangeAtIndex:1]];
}

@end
