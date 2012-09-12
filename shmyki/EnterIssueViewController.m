//
//  EnterIssueViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterIssueViewController.h"
#import "EnterLocationViewController.h"
#import "ShmykiContstants.h"
#import "AppDelegate.h"
#import "YourMykiCustomButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation EnterIssueViewController {
    BOOL isFirstTimePageLoad;
}

@synthesize commentsTextView, punchOnIssues, punchOnIsValid, twitterButton, facebookButton, punchOnTableView, punchOnTableViewWrapper, shadowWrapper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"yourVoice"];
        punchOnIssues = [[PunchOnIssues alloc] init];
        punchOnIsValid = NO;
        isFirstTimePageLoad = YES;
       // [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"TwitterCancelled" options:nil context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelTwitter) 
                                                     name:@"TwitterCancelled"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelFacebook) 
                                                     name:@"FacebookCancelled"
                                                   object:nil];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)cancelTwitter {
    [self.twitterButton setImage:[UIImage imageNamed: @"images/IconTwitterOff"] forState:UIControlStateNormal];
}

-(void)cancelFacebook {
    [self.facebookButton setImage:[UIImage imageNamed: @"images/IconFacebookOff"] forState:UIControlStateNormal];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [commentsTextView setDelegate:self];
   // [commentsTextView becomeFirstResponder];
    [self addHintTextToCommentsTextView];
    [commentsTextView resignFirstResponder];
    [commentsTextView setUserInteractionEnabled:YES];
    
   // self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.shadowWrapper.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowWrapper.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowWrapper.layer.shadowOpacity = .90f;
    self.shadowWrapper.layer.shadowRadius = 3.0f;
    
    //TODO TRY THIS FOR IOS5
    
    /*
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIColor colorWithRed:220.0/255.0 green:104.0/255.0 blue:1.0/255.0 alpha:1.0], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    */

    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

-(void)viewDidAppear: (BOOL)animated { 
    [super viewDidAppear:animated];
}  

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    [super viewWillAppear:animated];
}

-(void)popNavigationController {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.punchOnIssues.issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%i",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];

        
    }
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"Select a problem";   
        [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
        [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 1 && isFirstTimePageLoad) {
        isFirstTimePageLoad = NO;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}



#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0) {  
        for(int i=0; i< [self.punchOnIssues.issues count]; i++ ) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [tableView cellForRowAtIndexPath:currentIndexPath].accessoryType = UITableViewCellAccessoryNone;
        }
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
        
        if(indexPath.row != 1) {
            double delayInSeconds = .4;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIViewController *enterLocationViewController = [[EnterLocationViewController alloc] initWithNibName:@"EnterLocationViewController" bundle:nil];
                [self.navigationController pushViewController:enterLocationViewController animated:YES];
            });
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
        
        return YES;
    } else if ([textView.text length] == 1 && [text isEqualToString:@""]){
        [self addHintTextToCommentsTextView];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

   /* if (commentsTextView.hasText && ![commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]){
       punchOnIsValid = YES;
       self.navigationItem.rightBarButtonItem.enabled = YES;
   } else {
       punchOnIsValid = NO;
       self.navigationItem.rightBarButtonItem.enabled = NO;
   }*/
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = nil;

    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Done" withTarget:self withAction:@selector(doneAddingComments)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView { 

}

-(void) doneAddingComments {

    BOOL enableRightBarButton;
    
    if ([commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]) { 
        enableRightBarButton = NO;
    } else if([commentsTextView.text length] > 0) {
        enableRightBarButton = YES;
    } else {
        enableRightBarButton = NO;
        [self addHintTextToCommentsTextView];
    }
    [commentsTextView resignFirstResponder];

    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    self.navigationItem.rightBarButtonItem.enabled = enableRightBarButton;
}
                                                                   
#pragma mark actions

- (void) issueEntered {
    NSString *savedComment = @"";
    if(![commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]) {
        savedComment = commentsTextView.text;
    }
    
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog] setMessage:savedComment];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] postToFacebook];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] postToTwitter];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveCurrentUsersPunchOnLog];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)toggleTwitterButton:(id)sender {
    BOOL twitterIsSelected =  [(AppDelegate*)[[UIApplication sharedApplication]delegate] isTwitterRequired];
    if (twitterIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOn"] forState:UIControlStateNormal];
        [self presentTwitterLoginIfRequired];
    }
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] setIsTwitterRequired:!twitterIsSelected];
}

- (IBAction)toggleFacebookButton:(id)sender {
    BOOL facebookIsSelected =  [(AppDelegate*)[[UIApplication sharedApplication]delegate] isFaceBookRequired];
    if (facebookIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOn"] forState:UIControlStateNormal];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logInToFacebook];
    }
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] setIsFaceBookRequired:!facebookIsSelected];
}

#pragma  mark helper methods 

- (void) addHintTextToCommentsTextView {
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];
    commentsTextView.selectedRange = NSMakeRange(0, 0);
    
}

- (void) removeHintTextToCommentsTextView {
//    [commentsTextView setUserInteractionEnabled:YES];
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeDefault;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
	[commentsTextView setTextColor:[UIColor blackColor]];
}

-(void) presentTwitterLoginIfRequired {
    UIViewController* loginViewController = [(AppDelegate*)[[UIApplication sharedApplication]delegate] getlogInToTwitterViewController];  
    //[(SA_OAuthTwitterController*)loginViewController setDelegate:self];
    if (loginViewController != nil) {
        [self presentModalViewController: loginViewController animated: YES]; 
    }
}

@end
