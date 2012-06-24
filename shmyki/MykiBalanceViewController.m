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

@synthesize mykiLoginUrl, mykiWebstiteWebView, userIsLoggedIn, mykiAccountInformation, errorLoadingBalance;
@synthesize topView, bottomView, loginTableView, loginScrollView, pageScrollView, balanceDisplayView, errorView;
@synthesize usernameTextField, passwordTextField;
@synthesize balanceHeaderLabel, balanceMykiPassExpiryLabel, balanceMykiPassAdditionalLabel, balanceMykiMoneyAmountLabel, balanceMykiMoneyAdditionalLabel, balanceFooterLabelOne, balanceFooterLabelTwo, balanceSeperatorImage;
@synthesize HUD;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mykiAccountInformation = [[MykiAccountInformation alloc] init]; 
        [mykiAccountInformation loadAccountInformation];
        mykiLoginUrl = MYKI_LOGIN_URL;
        mykiWebstiteWebView = [[UIWebView alloc] init];
        mykiWebstiteWebView.delegate = self;
        userIsLoggedIn = NO;

        [self retrieveMykiBalance];

        usernameTextField = [self setUpTextField:usernameTextField withText:@"Username" withUserDetail:[mykiAccountInformation mykiUsername] withReturnKey:UIReturnKeyNext withTag:USERNAME_TEXTFIELD_TAG];
        passwordTextField = [self setUpTextField:passwordTextField withText:@"Password" withUserDetail:[mykiAccountInformation mykiPassword] withReturnKey:UIReturnKeyDone withTag:PASSWORD_TEXTFIELD_TAG];
        passwordTextField.secureTextEntry = YES;
        
        [self setTitle:@"Balances"];
        [[self navigationItem] setTitle:@"Balances"];
        self.tabBarItem.image = [UIImage imageNamed:@"images/TabBalanceOff"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self
                                                  action:@selector(switchToLoginState)];
        self.navigationItem.rightBarButtonItem.enabled = NO;

        
    }
    return self;
}

#pragma mark setUp
-(UITextField*) setUpTextField:(UITextField*)textField withText:(NSString*)defaultText withUserDetail:(NSString*)userDetail withReturnKey:(UIReturnKeyType)returnKey withTag:(int)tag {
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 235, 40)];
    textField.delegate = self;
    [textField setFont:[UIFont systemFontOfSize:14.0f]];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if ([userDetail isEqualToString:@""]) {
        textField.text = defaultText;
        [textField setTextColor:[UIColor grayColor]];
    } else {
        textField.text = userDetail;
        [textField setTextColor:[UIColor blackColor]];
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
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.labelText = @"Connecting";

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl]];
    [mykiWebstiteWebView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    if(userIsLoggedIn) {
 
        NSString *fullURL = MYKI_ACCOUNT_INFO_URL;
        NSURL *url = [NSURL URLWithString:fullURL];  
        NSError *error;
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
        if([page length] == 0 || [mykiAccountInformation isLoginUnsuccessful:page]) {
            self.errorLoadingBalance = YES;
            self.userIsLoggedIn = NO;
            [self switchToErrorState];
        } else {
            [mykiAccountInformation extractMykiAccountInfoFromHtml:page];
            self.errorLoadingBalance = NO;
            [self showMykiAccountInformation];
            self.userIsLoggedIn = NO;
            [self switchToSuccessState];
        }
        [HUD hide:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
    if(errorLoadingBalance) {
       // [balanceMykiPassExpiryLabel setText: [mykiAccountInformation currentMykiPassActive]];
        //[balanceMykiMoneyAmountLabel setText: [mykiAccountInformation currentMykiMoneyBalance]];

    } else {
        [balanceMykiPassExpiryLabel setText: [mykiAccountInformation currentMykiPassActive]];
        [balanceMykiMoneyAmountLabel setText: [mykiAccountInformation currentMykiMoneyBalance]];
        [balanceMykiMoneyAdditionalLabel setText:[mykiAccountInformation mykiMoneyTopUpInProgress]];
        [balanceMykiPassAdditionalLabel setText:[mykiAccountInformation currentMykiPassNotYetActive]];

    }
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
            [passwordTextField resignFirstResponder];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    int textFieldTag = textField.tag;        
    if(textFieldTag == USERNAME_TEXTFIELD_TAG) {
        if([usernameTextField.text isEqualToString:@"Username"]) {
            [usernameTextField setText: @""];
            [usernameTextField setTextColor:[UIColor blackColor]];
        }
    } else if (textFieldTag == PASSWORD_TEXTFIELD_TAG) {
        if([passwordTextField.text isEqualToString:@"Password"]) {
            [passwordTextField setText: @""];
            [passwordTextField setTextColor:[UIColor blackColor]];
        }
    }
}       

- (void)textFieldDidEndEditing:(UITextField *)textField {
    int textFieldTag = textField.tag;        
    if(textFieldTag == USERNAME_TEXTFIELD_TAG) {
        if([usernameTextField.text isEqualToString:@""]) {
            [usernameTextField setText: @"Username"];
            [usernameTextField setTextColor:[UIColor grayColor]];
        }
    } else if (textFieldTag == PASSWORD_TEXTFIELD_TAG) {
        if([passwordTextField.text isEqualToString:@""]) {
            [passwordTextField setText: @"Password"];
            [passwordTextField setTextColor:[UIColor grayColor]];
        } else {
            [self retryRetrieveMykiBalance];
        }
    }
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
    [mykiAccountInformation setMykiUsername: usernameTextField.text];
    [mykiAccountInformation setMykiPassword: passwordTextField.text];
    [mykiAccountInformation saveAccountInformation];
    self.userIsLoggedIn = NO;
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
}

-(void)switchToLoginState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 224, 320, 205);
    self.errorView.frame = CGRectMake(0, 705, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    [UIView commitAnimations];
}

-(void)switchToErrorState {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4];
    self.bottomView.frame = CGRectMake(0, 705, 320, 205);
    self.errorView.frame = CGRectMake(0, 224, 320, 150);
    [self drawBalanceViewGradientWithCornersWithActiveState:NO];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    [UIView commitAnimations];
}

-(IBAction)tryAgainButtonTapped:(id)sender {
    //[self switchToLoginState];
    [self retrieveMykiBalance];
}
     
@end
