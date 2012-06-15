//
//  MykiBalanceViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 15/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "MykiBalanceViewController.h"
#import "ShmykiContstants.h"

@implementation MykiBalanceViewController

@synthesize mykiPassword, mykiUsername, mykiLoginUrl, mykiWebstiteWebView, userIsLoggedIn, mykiAccountInformation, label1;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl]];
    [mykiWebstiteWebView loadRequest:requestObj];
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(userIsLoggedIn) {
 
        NSString *fullURL = MYKI_ACCOUNT_INFO_URL;
        NSURL *url = [NSURL URLWithString:fullURL];  
        NSError *error;
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
        [self extractMykiAccountInfoFromHtml:page];

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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) extractMykiAccountInfoFromHtml:(NSString*) page {
    NSError *error;
    NSString *accountBalanceRegExString = @"<strong>Current myki money balance</strong></td>\\s+<td>\\s+(.+)</td>";
    NSRegularExpression *accountBalanceRegEx = [NSRegularExpression regularExpressionWithPattern:accountBalanceRegExString options:0 error:&error];
    
    NSTextCheckingResult *result = [accountBalanceRegEx firstMatchInString:page options:0 range:NSMakeRange(0, [page length])];
    NSRange range = [result rangeAtIndex:1];
    
    [mykiAccountInformation setCurrentMykiMoneyBalance:[page substringWithRange:range]];
    [label1 setText:[mykiAccountInformation currentMykiMoneyBalance]];
}

@end
