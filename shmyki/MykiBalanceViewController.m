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
#import "BalanceInfoView.h"
#import "TopUpWebViewViewController.h"

@implementation MykiBalanceViewController

@synthesize mykiLoginUrl, mykiWebstiteWebView, mykiAccountInformation;
@synthesize topView, bottomView, loginTableView, loginScrollView, pageScrollView, errorView, errorTextView, errorTextLabel, isInternetDown;
@synthesize usernameTextField, passwordTextField;
@synthesize HUD, timer, refreshButton, isUserLoginAttempted, isProblemWithMykiCredentials, invalidCredentialsLabel, dateDisplayHelper, pageControl, pagingScrollView;
@synthesize balanceFooterLabelOne,balanceFooterLabelTwo, balanceHeaderLabelOne,balanceHeaderLabelTwo;
@synthesize numPages, currentlyRequestedCard, isActiveState;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        mykiAccountInformation = [[MykiAccountInformation alloc] init]; 
        [mykiAccountInformation loadAccountInformation];
        [mykiAccountInformation loadAccountBalanceInformation];
        mykiLoginUrl = MYKI_LOGIN_URL;

        mykiWebstiteWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
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
    
    [self.balanceFooterLabelOne setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [self.balanceFooterLabelTwo setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [self.balanceHeaderLabelOne setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
    [self.balanceHeaderLabelTwo setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    //[self.view addSubview:self.mykiWebstiteWebView];

    self.pageControl = [[PageControl alloc] initWithFrame:CGRectMake(141, 150, 39, 36)];
	self.pageControl.currentPage = 1;
    self.pageControl.hidden = YES;
    
    self.numPages = MAX(1, self.mykiAccountInformation.mykiCards.count);
    self.currentlyRequestedCard = 0;
    self.isRequestingNumberOfCards = YES;
	self.pageControl.numberOfPages = self.numPages;

    [self.topView addSubview:self.pageControl];
    
    self.isActiveState = NO;
    [self showMykiAccountInformation];
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
        self.numPages = MAX(1, self.mykiAccountInformation.mykiCards.count);
        self.currentlyRequestedCard = 0;
        self.isRequestingNumberOfCards = YES;
        self.pageControl.numberOfPages = self.numPages;
        
        
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
        self.isRequestingMoreCardData = YES;
        
    }else if ([pageTitle isEqualToString:@"Manage my card"]) {
        [self resetTimer];
        [self requestNumberOfCardsIfRequired];
        
        if (self.isRequestingMoreCardData) {

            NSString *currentHTMLPage = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
            [mykiAccountInformation extractMykiAccountInfoFromHtml:currentHTMLPage forCardNumber:self.currentlyRequestedCard];
            self.currentlyRequestedCard++;
            
            if (self.currentlyRequestedCard >= self.numPages) {
                self.isRequestingMoreCardData = NO;
                [self finishedProcessingBalances];
            } else {
                [self changeCardSelectorTo:self.currentlyRequestedCard];
                [self tapChangeCardButton];
            }
        }
    } else if ([pageTitle isEqualToString:@"Top up your myki"]) {
       // NSLog(@"top up");
        if (self.topUpType == topUpTypeMykiMoney) {
            
        } else {
            
        }

        if (self.topUpPage == topUpPageReviewTopUp) {
            NSLog(@"review top up");
            [self switchToSuccessState];
            self.mykiWebstiteWebView.frame = CGRectMake(0, 0, 320, 416);
            self.mykiWebstiteWebView.hidden = NO;
            [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:JAVASCRIPT_RESTYLE_REVIEW_PAGE];
            
            TopUpWebViewViewController *mykiWebViewController= [[TopUpWebViewViewController alloc] init];
            mykiWebViewController.view.backgroundColor = [UIColor whiteColor];
            [mykiWebViewController.view addSubview:self.mykiWebstiteWebView];
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:mykiWebViewController];
            self.topUpPage = topUpPagePostReviewTopUp;
            [HUD hide:YES];
            [self presentViewController:navigationController animated:YES completion:nil];
        } else if (self.topUpPage == topUpPageReviewTopUp) {
            NSLog(@"post review");
        } else {
            HUD.labelText = @"Pre filling your top up data";
            NSLog(@"Choose top up");
            timer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(pollForChooseTopUpPageLoaded:) userInfo:nil repeats: YES];
            
        }
    } else if ([pageTitle isEqualToString:@"Top up myki money"]) {
        NSLog(@"Specify top up");
        NSString *specifyTopUpPage = JAVASCRIPT_SPECIFY_TOP_UP_SUBMIT;
        self.topUpPage = topUpPageReviewTopUp;
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:specifyTopUpPage];
        
    } else {
        [self switchToErrorState];
        [timer invalidate];
        [HUD hide:YES];
        NSLog(@"Some other Page title: %@", pageTitle);
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog (@"Error!: %@", error);
}


-(void) changeCardSelectorTo:(int)cardNumber{
    NSString* changeCardJavascript = [NSString stringWithFormat: @"var cardDropdown = document.getElementById('ctl00_uxContentPlaceHolder_uxCardList');var numberOfCards = cardDropdown.options.length;for (var i=0; i<numberOfCards; i++){if (cardDropdown.options[i].value == cardDropdown.options[%d].value){cardDropdown.options[i].selected = true;break;}}",cardNumber];
    
    [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: changeCardJavascript];
}

-(void) tapChangeCardButton {
    NSString* changeCardSubmitJavascript = @"var submitButton = document.getElementById(\"ctl00_uxContentPlaceHolder_uxGo\"); submitButton.click();";
    [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: changeCardSubmitJavascript];
}

-(void) requestNumberOfCardsIfRequired {
    if(self.isRequestingNumberOfCards) {
        NSString* numberOfCardsJavascript = @"document.getElementById('ctl00_uxContentPlaceHolder_uxCardList').options.length";
        NSString* numberOfCardsReturnValue = [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:numberOfCardsJavascript];
        self.numPages = [numberOfCardsReturnValue integerValue];
        self.isRequestingNumberOfCards = NO;
        self.pageControl.numberOfPages = self.numPages;
        self.pageControl.hidden = !(self.numPages > 1);
    }
}

#pragma mark account info helpers

-(void) finishedProcessingBalances {
    [timer invalidate];
    [self showMykiAccountInformation];
    [self switchToSuccessState];
    [HUD hide:YES];
}

-(void) showMykiAccountInformation {
    [self.pagingScrollView reloadData];
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
    self.isActiveState = YES;
    [self.pagingScrollView reloadData];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
    [self updateRefreshButton];
}

-(void)switchToLoginState {
    self.isActiveState = NO;
    [self.pagingScrollView reloadData];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    [self dismissKeyboard];
    self.bottomView.frame = CGRectMake(0, 224, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [UIView commitAnimations];
    
    if (self.isUserLoginAttempted) {
  
        self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(switchToSuccessState)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)switchToLoggingInState {
    self.isActiveState = NO;
    [self.pagingScrollView reloadData];
    self.invalidCredentialsLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(userCanceledLogin)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);

    [UIView commitAnimations];
}

-(void)switchToErrorState {
    self.isActiveState = NO;
    [self.pagingScrollView reloadData];
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
        [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Edit" withTarget:self withAction:@selector(switchToLoginState)];
    }
}

-(IBAction)tryAgainButtonTapped:(id)sender {
    [self retrieveMykiBalance];
}

-(IBAction)topUpButtonTapped:(id)sender {
    
    self.topUpType = topUpTypeMykiMoney;
    [self switchToLoggingInState];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.labelText = @"Connecting to Myki top up";
    [HUD show:YES];
    NSString* chooseTopUpURL = MYKI_ACCOUNT_CHOOSE_TOP_UP_PAGE_URL;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:chooseTopUpURL]];
    [mykiWebstiteWebView loadRequest:requestObj];
}

-(void) updateRefreshButton {
    NSString* updatedDate =  [dateDisplayHelper getDisplayForDate:[mykiAccountInformation lastUpdatedDate] forPage:YourMykiIBalancePage];
    
    if (updatedDate ==nil) {
        [self.refreshButton setHidden:YES];
    } else {
    
        [self.refreshButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        //[self.refreshButton setTitle: [NSString stringWithFormat:@"Last Updated %@", updatedDate] forState:UIControlStateNormal];
        [self.refreshButton setTitle: @"Top Up" forState:UIControlStateNormal];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
}

#pragma mark - MHPagingScrollViewDelegate

- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return self.numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
    BalanceInfoView * balanceInfoView = [[BalanceInfoView alloc] init];
    balanceInfoView.frame = CGRectMake(20, 50, 280, 100);

    if([self.mykiAccountInformation.mykiCards count]) {
        [balanceInfoView.balanceMykiPassExpiryLabel setText:[mykiAccountInformation transformMykiPassToMykiPassLabelForCardNumber:index]];
        [balanceInfoView.balanceMykiMoneyAmountLabel setText:[mykiAccountInformation transformMykiMoneyToMykiMoneyLabelForCardNumber:index]];
        [balanceInfoView.balanceMykiPassAdditionalLabel setText:[mykiAccountInformation transformCurrentMykiPassNotYetActiveToLabelForCardNumber:index]];
        [balanceInfoView.balanceMykiMoneyAdditionalLabel setText:[mykiAccountInformation transformMykiMoneyTopUpInProgressToLabelForCardNumber:index]];
        
        [self.balanceHeaderLabelOne setText:[mykiAccountInformation transformAccountInfoToHeaderLabelOneForCardNumber:index]];
        [self.balanceHeaderLabelTwo setText:[mykiAccountInformation transformAccountInfoToHeaderLabelTwoForCardNumber:index]];
        [self.balanceFooterLabelOne setText:[mykiAccountInformation transformAccountInfoToBottomLabelOneForCardNumber:index]];
        [self.balanceFooterLabelTwo setText:[mykiAccountInformation transformAccountInfoToBottomLabelTwoForCardNumber:index]];
    }
    
    [balanceInfoView drawBalanceViewGradientWithCornersWithActiveState:self.isActiveState];
    return balanceInfoView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage=page;
}

-(void)pollForChooseTopUpPageLoaded:(id) sender {
    NSLog(@"Robert");
    NSString *submitChooseTopUpPage = JAVASCRIPT_CHOOSE_TOP_UP_SUMBIT;
    

    NSError *error;
    NSString *currentHTMLPage = [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:@"document.all[0].innerHTML"];
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"id=\"(ctl00_uxContentPlaceHolder_uxCardlist)\"" options:0 error:&error];
    NSTextCheckingResult *result = [regEx firstMatchInString:currentHTMLPage options:0 range:NSMakeRange(0, [currentHTMLPage length])];
    if(result) {
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: submitChooseTopUpPage];
        self.topUpPage= topUpPageSpecifyTopUp;
        [timer invalidate];
    }
}


@end
