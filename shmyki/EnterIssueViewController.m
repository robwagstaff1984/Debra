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

@implementation EnterIssueViewController

@synthesize commentsTextView, punchOnIssues, punchOnIsValid, twitterButton, facebookButton, punchOnTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"yourVoice"];
        punchOnIssues = [[PunchOnIssues alloc] init];
        punchOnIsValid = NO;
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
    
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //self.navigationItem.leftBarButtonItem.style = UIBarButtonSystemItemCancel;
    

   // [punchOnTableView selectRowAtIndexPath:indexPath 
   ////                        animated:NO 
       //              scrollPosition:UITableViewScrollPositionMiddle];
   // [[punchOnTableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:NO];
    //[punchOnTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
    
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

    static NSString *cellIdentifier = @"punchOnCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];
        
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}



#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    [tableView cellForRowAtIndexPath:firstCell].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if(indexPath.row != 0) {
        double delayInSeconds = .4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIViewController *enterLocationViewController = [[EnterLocationViewController alloc] initWithNibName:@"EnterLocationViewController" bundle:nil];
            [self.navigationController pushViewController:enterLocationViewController animated:YES];
        });
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

    [commentsTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    
    if([commentsTextView.text length] > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self addHintTextToCommentsTextView];
    }
    [commentsTextView resignFirstResponder];
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
    //[(AppDelegate*)[[UIApplication sharedApplication] delegate] saveCurrentUsersPunchOnLog];
    
    
    UIViewController *enterLocationViewController = [[EnterLocationViewController alloc] initWithNibName:@"EnterLocationViewController" bundle:nil];
    [self.navigationController pushViewController:enterLocationViewController animated:YES];
    //[self.navigationController dismissModalViewControllerAnimated:YES];
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
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];
    commentsTextView.selectedRange = NSMakeRange(0, 0);
    
}

- (void) removeHintTextToCommentsTextView {
//    [commentsTextView setUserInteractionEnabled:YES];
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeDefault;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
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
