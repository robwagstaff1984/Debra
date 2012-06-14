//
//  EnterIssueViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterIssueViewController.h"
#import "Parse/Parse.h"

@implementation EnterIssueViewController

@synthesize commentsTextView, punchOnIssues, punchOnTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        punchOnIssues = [[PunchOnIssues alloc] init];
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
    
    [self.commentsTextView setDelegate:self];
    [self.commentsTextView setReturnKeyType:UIReturnKeyDone];

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
    }
    
    cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedTableViewCell = [self.punchOnTableView cellForRowAtIndexPath:indexPath];
    if ( selectedTableViewCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selectedTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        selectedTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [selectedTableViewCell setSelected:NO animated:YES];
}

@end
