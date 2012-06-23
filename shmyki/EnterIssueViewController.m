//
//  EnterIssueViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterIssueViewController.h"
#import "EnterLocationViewController.h"
#import "Parse/Parse.h"
#import "ShmykiContstants.h"


@implementation EnterIssueViewController

@synthesize commentsTextView, punchOnIssues, punchOnTableView, facebookIsSelected, twitterIsSelected, punchOnIsValid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        punchOnIssues = [[PunchOnIssues alloc] init];
        facebookIsSelected = NO;
        twitterIsSelected = NO;
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
    [commentsTextView setReturnKeyType:UIReturnKeyDone];
    [self addHintTextToCommentsTextView];
 
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                    action:@selector(issueEntered)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [super viewDidLoad];
    /*   PFObject *punchOnLog = [PFObject objectWithClassName:@"PunchOnLog"];
     [punchOnLog setObject:locationTextField.text forKey:@"location"];
     [punchOnLog setObject:commentsTextView.text forKey:@"message"];
     [punchOnLog saveInBackground];*/
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
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

#pragma mark tableView delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedTableViewCell = [self.punchOnTableView cellForRowAtIndexPath:indexPath];
    [selectedTableViewCell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedTableViewCell = [self.punchOnTableView cellForRowAtIndexPath:indexPath];
    [selectedTableViewCell setSelected:NO animated:YES];
    
    if ( selectedTableViewCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selectedTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        selectedTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
    }
}       

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.hasText){
        [self addHintTextToCommentsTextView];
    }
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
    UIViewController *enterIssueViewController = [[EnterLocationViewController alloc] initWithNibName:@"EnterLocationViewController" bundle:nil];
    [self.navigationController pushViewController:enterIssueViewController animated:YES];
}

- (IBAction)toggleTwitterButton:(id)sender {
    if (twitterIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOn"] forState:UIControlStateNormal];
    }
    twitterIsSelected = !twitterIsSelected;
}

- (IBAction)toggleFacebookButton:(id)sender {
    if (facebookIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOn"] forState:UIControlStateNormal];
    }
    facebookIsSelected = !facebookIsSelected;
}

#pragma  mark helper methods 

- (void) addHintTextToCommentsTextView {
    [commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];

}

- (void) removeHintTextToCommentsTextView {
    [commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont italicSystemFontOfSize:18.0f]];
	[commentsTextView setTextColor:[UIColor blackColor]];
}

@end
