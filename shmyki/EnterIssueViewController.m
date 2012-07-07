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

@implementation EnterIssueViewController

@synthesize commentsTextView, punchOnIssues, punchOnIsValid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"yourMyki"];
        punchOnIssues = [[PunchOnIssues alloc] init];
        punchOnIsValid = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [commentsTextView setDelegate:self];
    [commentsTextView becomeFirstResponder];
    [self addHintTextToCommentsTextView];
    
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                    action:@selector(issueEntered)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemCancel;
    
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
   // [self.navigationController setNavigationBarHidden:NO]; 
//    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(popNavigationController)];
//    self.navigationItem.leftBarButtonItem = _backButton;
    //   self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(popNavigationController)];
    self.navigationItem.leftBarButtonItem = _backButton;
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

    static NSString *cellIdentifier = @"punchOnCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
    } else if ([textView.text length] == 1 && [text isEqualToString:@""]){
        [self addHintTextToCommentsTextView];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    if (commentsTextView.hasText){
       punchOnIsValid = YES;
       self.navigationItem.rightBarButtonItem.enabled = YES;
   } else {
       punchOnIsValid = NO;
       self.navigationItem.rightBarButtonItem.enabled = NO;
   }
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
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
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
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];
    commentsTextView.selectedRange = NSMakeRange(0, 0);
}

- (void) removeHintTextToCommentsTextView {
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeDefault;
    [commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor blackColor]];
}

-(void) presentTwitterLoginIfRequired {
    UIViewController* loginViewController = [(AppDelegate*)[[UIApplication sharedApplication]delegate] getlogInToTwitterViewController];  
    if (loginViewController != nil) {
        [self presentModalViewController: loginViewController animated: YES]; 
    }
}

@end
