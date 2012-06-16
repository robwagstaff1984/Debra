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
@synthesize topView, bottomView, loginTableView, loginScrollView, pageScrollView;
@synthesize usernameTextField, passwordTextField;
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
        usernameTextField = [[UITextField alloc] init];
        passwordTextField = [[UITextField alloc] init];
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;
        [self setTitle:@"Balances"];
        [[self navigationItem] setTitle:@"Balances"];
        
        //[self.bottomView addSubview:myView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewToPositionForNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewToPositionForNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:mykiLoginUrl]];
    [mykiWebstiteWebView loadRequest:requestObj];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = bottomView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blueColor ] CGColor], nil];
    [bottomView.layer insertSublayer:gradient atIndex:0];

	loginScrollView.layer.cornerRadius = 8;
	[loginScrollView setShowsVerticalScrollIndicator:NO];
    loginScrollView.scrollEnabled = NO;
	
	//loginTableView = [[U alloc] initWithStyle:UITableViewStylePlain];
	loginTableView.scrollEnabled = NO;
	loginTableView.layer.cornerRadius = 8;
	
	//[scrollView setContentSize:CGSizeMake(300, 88)];
	//table.tableView.frame = CGRectMake(0, 0, 300, 88);
	//[scrollView addSubview:table.tableView];
    
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

#pragma mark tableViewDataSource delegate
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
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 235, 40)];
        [textField setFont:[UIFont systemFontOfSize:14.0f]];
        [textField setTextColor:[UIColor grayColor]];
        textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.row == 0) {
            textField.text = @"Username";
        } else {
            textField.text = @"Password";
        }
        [cell.contentView addSubview:textField];
        
    }
    
    return cell;
}


#pragma mark textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)scrollViewToPositionForNotification:(NSNotification*)notification {
    
    float position;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        position = 200.0;
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

#pragma  mark helper methods 

- (void) addHintTextToCommentsTextView {
    /*[commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];*/
    
}
- (void) removeHintTextToCommentsTextView {
    /*[commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor blackColor]];*/
}

     
     
@end
