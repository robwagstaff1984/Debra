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

@synthesize mykiLoginUrl, mykiWebstiteWebView, userIsLoggedIn, mykiAccountInformation;
@synthesize topView, bottomView, loginTableView, loginScrollView, pageScrollView, balanceDisplayView, errorView;
@synthesize usernameTextField, passwordTextField;
@synthesize balanceHeaderLabel, balanceMykiPassExpiryLabel, balanceMykiPassAdditionalLabel, balanceMykiMoneyAmountLabel, balanceMykiMoneyAdditionalLabel, balanceFooterLabelOne, balanceFooterLabelTwo, balanceSeperatorImage;
@synthesize HUD, timer;


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
        userIsLoggedIn = NO;
        
        usernameTextField = [self setUpTextField:usernameTextField withText:@"Username" withUserDetail:[mykiAccountInformation mykiUsername] withReturnKey:UIReturnKeyNext withTag:USERNAME_TEXTFIELD_TAG];
        passwordTextField = [self setUpTextField:passwordTextField withText:@"Password" withUserDetail: [mykiAccountInformation mykiPassword] withReturnKey:UIReturnKeyDone withTag:PASSWORD_TEXTFIELD_TAG];        
        
        passwordTextField.clearsOnBeginEditing = NO;
        
        [self setTitle:@"Balances"];
        [[self navigationItem] setTitle:@"Balances"];
        self.tabBarItem.image = [UIImage imageNamed:@"images/TabBalanceOff"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self
                                                  action:@selector(switchToLoginState)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if([usernameTextField.text length] != 0 && [passwordTextField.text length] != 0) {
            [self retrieveMykiBalance];
        } else {
            [self switchToLoginState];
        }
    }
    return self;
}

#pragma mark setUp
-(UITextField*) setUpTextField:(UITextField*)textField withText:(NSString*)defaultText withUserDetail:(NSString*)userDetail withReturnKey:(UIReturnKeyType)returnKey withTag:(int)tag {
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 235, 40)];
    textField.delegate = self;
    [textField setFont:[UIFont systemFontOfSize:14.0f]];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.text = userDetail;
    [textField setPlaceholder:defaultText];
    
    /*if ([userDetail length] == 0) {
        [textField setTextColor:[UIColor grayColor]];
    } else {
        [textField setTextColor:[UIColor blackColor]];
    }*/

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)retrieveMykiBalance {

    timer = [NSTimer scheduledTimerWithTimeInterval: 40.0 target:self selector:@selector(cancelRequest:) userInfo:nil repeats: NO];
    
    //timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(cancelRequest:) userInfo:nil repeats:NO];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.labelText = @"Connecting";

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0f];
    [mykiWebstiteWebView loadRequest:requestObj];
    
}

-(void) cancelRequest:(NSTimer*) theTimer {

    [mykiWebstiteWebView stopLoading];
    self.userIsLoggedIn = NO;
    [HUD hide:YES];
    [self switchToErrorState];
    NSLog(@"error biatch");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(userIsLoggedIn) {
        // [webView stopLoading];
        NSString *fullURL = MYKI_ACCOUNT_INFO_URL;
        NSURL *url = [NSURL URLWithString:fullURL];  
        NSError *error;
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
        [timer invalidate];
        if([page length] == 0 || [mykiAccountInformation isLoginUnsuccessful:page]) {
            self.userIsLoggedIn = NO;
            [self switchToErrorState];
            [HUD hide:YES];
        } else {
            [mykiAccountInformation extractMykiAccountInfoFromHtml:page];
            self.userIsLoggedIn = NO;
            [self showMykiAccountInformation];
            [self switchToSuccessState];
            [HUD hide:YES];
        }
    } else {
               
        NSString *populateUserNameJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_USERNAME, [mykiAccountInformation mykiUsername]];
        NSString *populatePasswordJavascript = [NSString stringWithFormat:JAVASCRIPT_ENTER_PASSWORD, [mykiAccountInformation mykiPassword]];
        NSString *submitMykiLoginField = JAVASCRIPT_CLICK_SUBMIT; 
        
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populateUserNameJavascript];
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString: populatePasswordJavascript];
        [self.mykiWebstiteWebView stringByEvaluatingJavaScriptFromString:submitMykiLoginField]; 

        userIsLoggedIn = YES;   
        HUD.labelText = @"Retrieving Balance";
    }
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


-(void) retryRetrieveMykiBalance {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self retrieveMykiBalance];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark move views     
-(void)switchToSuccessState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:YES];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLine.png"];
    [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)switchToLoginState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 224, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)switchToErrorState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 224, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(IBAction)tryAgainButtonTapped:(id)sender {
    //[self switchToLoginState];
    [self retrieveMykiBalance];
}
     
@end
