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
#import "DateDisplayHelper.h"
#import "YourMykiCustomButton.h"
#import "GANTracker.h"
#import "Reachability.h"
#import "DateDisplayHelper.h"

@implementation MykiBalanceViewController

@synthesize mykiLoginUrl, mykiWebstiteWebView, mykiAccountInformation;
@synthesize topView, bottomView, loginTableView, loginScrollView, pageScrollView, balanceDisplayView, errorView, errorTextView, errorTextLabel, isInternetDown;
@synthesize usernameTextField, passwordTextField;
@synthesize balanceHeaderLabel, balanceMykiPassExpiryLabel, balanceMykiPassAdditionalLabel, balanceMykiMoneyAmountLabel, balanceMykiMoneyAdditionalLabel, balanceFooterLabelOne, balanceFooterLabelTwo, balanceSeperatorImage;
@synthesize HUD, timer, refreshButton, isUserLoginAttempted, isProblemWithMykiCredentials, invalidCredentialsLabel, dateDisplayHelper;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        mykiAccountInformation = [[MykiAccountInformation alloc] init]; 
        [mykiAccountInformation loadAccountInformation];
        [mykiAccountInformation loadAccountBalanceInformation];
        mykiLoginUrl = MYKI_LOGIN_URL;

        mykiWebstiteWebView = [[UIWebView alloc] init];
        mykiWebstiteWebView.delegate = self;
        
        [self loadFirstTimeLogin];
        
        usernameTextField = [self setUpTextField:usernameTextField withText:@"Myki username" withUserDetail:[mykiAccountInformation mykiUsername] withReturnKey:UIReturnKeyNext withTag:USERNAME_TEXTFIELD_TAG];
        passwordTextField = [self setUpTextField:passwordTextField withText:@"Myki password" withUserDetail: [mykiAccountInformation mykiPassword] withReturnKey:UIReturnKeyDone withTag:PASSWORD_TEXTFIELD_TAG];
        
        passwordTextField.clearsOnBeginEditing = NO;
        
        [self setTitle:@"Balances"];
        [self.navigationItem setTitle:@"yourBalance"];
        if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)] ==YES) {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"images/TabBalanceOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"images/TabBalanceOff"]];
        } else {
            self.tabBarItem.image = [UIImage imageNamed:@"images/TabInspectOff"];
        }
        
        
        if(self.isUserLoginAttempted) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
        }
        
        
      /*  if([usernameTextField.text length] != 0 && [passwordTextField.text length] != 0) {
            [self retrieveMykiBalance];
        } else {
            [self switchToLoginState];
           // self.navigationItem.leftBarButtonItem = nil;
        }*/
        dateDisplayHelper = [[DateDisplayHelper alloc] init];
    }
    return self;
}

#pragma mark setUp
-(UITextField*) setUpTextField:(UITextField*)textField withText:(NSString*)defaultText withUserDetail:(NSString*)userDetail withReturnKey:(UIReturnKeyType)returnKey withTag:(int)tag {
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 235, 40)];
    textField.delegate = self;
    [textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.text = userDetail;
    [textField setPlaceholder:defaultText];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;

    if(tag == PASSWORD_TEXTFIELD_TAG) {
       textField.secureTextEntry = YES;
    }

    NSInteger usernameTag = tag;
    textField.tag = usernameTag;
    [textField setReturnKeyType:returnKey];
    return textField;
}
#pragma mark view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewToPositionForNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewToPositionForNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self drawBottomViewGradientWithCorners];
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    [self showMykiAccountInformation];
    
    self.topView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.topView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.topView.layer.shadowOpacity = .21f;
    self.topView.layer.shadowRadius = 2.0f;
    
    self.bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.bottomView.layer.shadowOffset = CGSizeMake(0.0, -2.0f);
    self.bottomView.layer.shadowOpacity = .21f;
    self.bottomView.layer.shadowRadius = 2.0f;
    
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAreaDismissAction)];
    UITapGestureRecognizer *cancelEditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topAreaDismissAction)];
    
    [self.bottomView addGestureRecognizer:cancelTap];
    [self.topView addGestureRecognizer:cancelEditTap];
    
    self.errorView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.errorView.layer.shadowOffset = CGSizeMake(0.0, -2.0f);
    self.errorView.layer.shadowOpacity = .21f;
    self.errorView.layer.shadowRadius = 2.0f;
    
    [balanceMykiPassExpiryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
//    [balanceMykiPassExpiryLabel setShadowColor:[UIColor darkGrayColor]];
     //[balanceMykiPassExpiryLabel setShadowColor:[UIColor colorWithHue:.586111 saturation:.130555 brightness:.197222 alpha:1]];
    [balanceMykiPassExpiryLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
    
    [balanceMykiPassExpiryLabel setShadowOffset:CGSizeMake(0, 1.0)];
    
    [balanceMykiMoneyAmountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
    [balanceMykiMoneyAmountLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
    [balanceMykiMoneyAmountLabel setShadowOffset:CGSizeMake(0, 1.0)];
    
    [balanceMykiMoneyAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [balanceMykiPassAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [balanceHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
    [balanceFooterLabelOne setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [balanceFooterLabelTwo setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateRefreshButton];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"yourBalance" withError:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)retrieveMykiBalance {
    if([usernameTextField.text length] != 0 && [passwordTextField.text length] != 0) {
        
        [self switchToLoggingInState];
        
        timer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(cancelRequest) userInfo:nil repeats: NO];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.dimBackground = YES;
        HUD.labelText = @"Connecting";
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl]];
        [mykiWebstiteWebView loadRequest:requestObj];
        
        if(![self isInternetConnected]) {
            self.isInternetDown = YES;
            [self switchToErrorState];
            [timer invalidate];
            [mykiWebstiteWebView stopLoading];
            [HUD hide:YES];
            self.isInternetDown = NO;
        }
    }
}

-(void) resetTimer {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(cancelRequest) userInfo:nil repeats: NO];
}

-(void) cancelRequest {
    [HUD hide:YES];
    [mykiWebstiteWebView stopLoading];
    [self switchToErrorState];
}

-(void) retryRetrieveMykiBalance {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if(!self.isUserLoginAttempted) {
        [self saveFirstTimeLogin];
    }
    [self retrieveMykiBalance];
}

-(void)stopRequest {
    [HUD hide:YES];
    if(mykiWebstiteWebView.loading) {
        [mykiWebstiteWebView stopLoading];
    }
    [timer invalidate];
}
#pragma mark webviewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([pageTitle isEqualToString:@"Login"]) {
        [self resetTimer];
        HUD.labelText = @"Logging in";
        NSString *currentPage = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        self.isProblemWithMykiCredentials = [mykiAccountInformation isProblemWithCredentials:currentPage];
        if (self.isProblemWithMykiCredentials) {
            [self switchToErrorState];
            [timer invalidate];
            [HUD hide:YES];
        } else {
            NSString *populateUserNameJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_USERNAME, [mykiAccountInformation mykiUsername]];
            NSString *populatePasswordJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_PASSWORD, [mykiAccountInformation mykiPassword]];
            NSString *submitMykiLoginField = JAVASCRIPT_CLICK_SUBMIT;
            
            [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populateUserNameJavascript];
            [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populatePasswordJavascript];
            [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:submitMykiLoginField];
        }
    } else if ([pageTitle isEqualToString:@"My myki account"]) {
        [self resetTimer];
        HUD.labelText = @"Retrieving Balance";
        
        NSString* manageMyCardUrl = MYKI_ACCOUNT_INFO_URL;
        NSURLRequest *manageMyCardRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:manageMyCardUrl]];
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mykiWebstiteWebView loadRequest:manageMyCardRequest];
        });
        
    }else if ([pageTitle isEqualToString:@"Manage my card"]) {
        [self resetTimer];
        NSString *currentPage = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        [self processMykiAccountBalancePageHTML:currentPage];
    }
    else {
        [self switchToErrorState];
        [timer invalidate];
        [HUD hide:YES];
        NSLog(@"Some other Page title: %@", pageTitle);
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog (@"Error!: %@", error);
}

#pragma mark account info helpers
-(void) processMykiAccountBalancePageHTML:(NSString*)mykiAccountBalancePageHTML  {
    [timer invalidate];
    [mykiAccountInformation extractMykiAccountInfoFromHtml:mykiAccountBalancePageHTML];
    [self showMykiAccountInformation];
    [self switchToSuccessState];
    [HUD hide:YES];
}

-(void) showMykiAccountInformation {

    [balanceMykiPassExpiryLabel setText: [mykiAccountInformation transformMykiPassToMykiPassLabel]];
    [balanceMykiMoneyAmountLabel setText: [mykiAccountInformation transformMykiMoneyToMykiMoneyLabel]];
    [balanceMykiMoneyAdditionalLabel setText:[mykiAccountInformation mykiMoneyTopUpInProgress]];
    [balanceMykiPassAdditionalLabel setText:[mykiAccountInformation currentMykiPassNotYetActive]];
    
    [balanceHeaderLabel setText: [mykiAccountInformation transformAccountInfoToHeaderLabel]];
    [balanceFooterLabelOne setText: [mykiAccountInformation transformAccountInfoToBottomLabelOne]];
    [balanceFooterLabelTwo setText: [mykiAccountInformation transformAccountInfoToBottomLabelTwo]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"mykiBalanceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.row == 0) {
            [cell.contentView addSubview:usernameTextField];
        } else {
            [cell.contentView addSubview:passwordTextField];
        }
    }
    return cell;
}

#pragma mark textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        int textFieldTag = textField.tag;        
        if(textFieldTag == USERNAME_TEXTFIELD_TAG) {          
            [passwordTextField becomeFirstResponder];
        } else if (textFieldTag == PASSWORD_TEXTFIELD_TAG) {
            if ([usernameTextField.text length] != 0 && [passwordTextField.text length] != 0) {
                [self retryRetrieveMykiBalance];
            }
            [mykiAccountInformation setMykiUsername: usernameTextField.text];
            [mykiAccountInformation setMykiPassword: passwordTextField.text];
            [mykiAccountInformation saveAccountInformation];
            [passwordTextField resignFirstResponder];
        }
    }
    return YES;
}

#pragma  mark helper methods 
-(void)scrollViewToPositionForNotification:(NSNotification*)notification {
    
    float position;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        position = 224.0;
        if(self.isUserLoginAttempted) {
            self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToSuccessState)];
        } else {
            self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToLoginState)];
        }
    } else {
        position = 0.0;
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, position, 0.0);
    pageScrollView.contentInset = contentInsets;
    pageScrollView.scrollIndicatorInsets = contentInsets;
    CGPoint scrollPoint = CGPointMake(0.0, position);
    [pageScrollView setContentOffset:scrollPoint animated:YES];
    
    [UIView commitAnimations];
}

- (void) drawBottomViewGradientWithCorners {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = bottomView.bounds;
    UIColor *startColour = [UIColor colorWithHue:.58333 saturation:0.35 brightness:0.88 alpha:1.0];
    UIColor *endColour = [UIColor colorWithHue:.58333 saturation:0.50 brightness:0.62 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    
    [bottomView.layer insertSublayer:gradient atIndex:0];
    loginScrollView.layer.cornerRadius = 8;
	[loginScrollView setShowsVerticalScrollIndicator:NO];
    loginScrollView.scrollEnabled = NO;
	
	loginTableView.scrollEnabled = NO;
	loginTableView.layer.cornerRadius = 8;
}

//CGContextDrawLinearGradient
-(void) drawBalanceViewGradientWithCornersWithActiveState:(BOOL)isActiveState {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = balanceDisplayView.bounds;
    UIColor *startColour;
    UIColor *endColour;
    if(isActiveState) {
        startColour = [UIColor colorWithHue:0.5833 saturation:0.50 brightness:0.62 alpha:1.0];
        endColour = [UIColor colorWithHue:0.5833 saturation:0.35 brightness:0.88 alpha:1.0];
    } else {
        startColour = [UIColor colorWithHue:0.0 saturation:0.00 brightness:0.45 alpha:1.0];
        endColour = [UIColor colorWithHue:0.0 saturation:0.00 brightness:0.70 alpha:1.0];
    }
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    balanceDisplayView.layer.cornerRadius = 10;
    gradient.cornerRadius = 10;
    
    CALayer *currentGradient = [balanceDisplayView.layer.sublayers objectAtIndex:0];
    if(currentGradient.position.x != 74) {
        [balanceDisplayView.layer replaceSublayer:[balanceDisplayView.layer.sublayers objectAtIndex:0] with:gradient];
    } else {
        [balanceDisplayView.layer insertSublayer:gradient atIndex:0];
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark dismissActions

-(void) topAreaDismissAction {
    if(self.isUserLoginAttempted) {
        [self switchToSuccessState];
    }
}


-(void) bottomAreaDismissAction {
    
    [self dismissKeyboard];
    if(self.isUserLoginAttempted) {
        self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToSuccessState)];
     } else {

         self.navigationItem.rightBarButtonItem = nil;
     }

}

#pragma mark move views   
-(void)switchToSuccessState {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:YES];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLine.png"];
    [UIView commitAnimations];
    
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
    
    [self updateRefreshButton];
    
}

-(void)switchToLoginState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    [self dismissKeyboard];
    self.bottomView.frame = CGRectMake(0, 224, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    [UIView commitAnimations];
    
    if (self.isUserLoginAttempted) {
  
        self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToSuccessState)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)switchToLoggingInState {
    self.invalidCredentialsLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(userCanceledLogin)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    //self.navigationItem.leftBarButtonItem = nil;
    [UIView commitAnimations];
}

-(void)switchToErrorState {
    if(self.isProblemWithMykiCredentials) {
        self.invalidCredentialsLabel.hidden = NO;
        [self switchToLoginState];
        self.isProblemWithMykiCredentials = NO;
    } else {
        if(self.isInternetDown) {
            self.errorTextLabel.text =@"No internet connection";
            self.errorTextView.text = @"There seems to be a problem with your internet connection. Please try again later";
        } else {
            self.errorTextLabel.text =@"Sorry there's been an error";
            self.errorTextView.text = @"We don't know what happened but please try again and let's hope it works this time";
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.4];
        self.bottomView.frame = CGRectMake(0, 705, 320, 205);
        self.errorView.frame = CGRectMake(0, 224, 320, 150);
        [self drawBalanceViewGradientWithCornersWithActiveState:NO];
        self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
        [UIView commitAnimations];
        //  self.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToSuccessState)];
        self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
    }
}

-(IBAction)tryAgainButtonTapped:(id)sender {
    //[self switchToLoginState];
    [self retrieveMykiBalance];
}

-(void) updateRefreshButton {
    NSString* updatedDate =  [dateDisplayHelper getDisplayForDate:[mykiAccountInformation lastUpdatedDate] forPage:YourMykiIBalancePage];
    
    if (updatedDate ==nil) {
        [self.refreshButton setHidden:YES];
    } else {
    
        [self.refreshButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [self.refreshButton setTitle: [NSString stringWithFormat:@"Last Updated %@", updatedDate] forState:UIControlStateNormal];
        [self.refreshButton setHidden:NO];
    }
}

-(void) userCanceledLogin {
    [HUD hide:YES];
    [mykiWebstiteWebView stopLoading];
    [self switchToSuccessState];
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
    [timer invalidate];
}
   
#pragma mark touch event

-(void) dismissKeyboard {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder]; 
}

#pragma firstTimeLogin

-(void) saveFirstTimeLogin {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoginAttempted = YES;
    [defaults setBool:YES forKey:@"isUserLoginAttempted"];
    
    [defaults synchronize];
}
-(void) loadFirstTimeLogin {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoginAttempted = [defaults boolForKey:@"isUserLoginAttempted"];
}

#pragma mark internet check

- (BOOL)isInternetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    Reachability *hostReachability = [Reachability reachabilityWithHostName: @"www.google.com"];
    NetworkStatus hostStatus = [hostReachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable) && !(hostStatus == NotReachable);
}
@end
