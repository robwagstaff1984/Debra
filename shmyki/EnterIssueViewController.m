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

@synthesize locationTextField, commentsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.locationTextField setDelegate:self];
    [self.locationTextField setReturnKeyType:UIReturnKeyDone];
    [self.locationTextField addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.commentsTextView setDelegate:self];
 //   [self.commentsTextView addTarget:self
   //                            action:@selector(textFieldFinished:)
     //                forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IBActions
- (IBAction)logIssue:(id)sender {
    
     PFObject *punchOnLog = [PFObject objectWithClassName:@"PunchOnLog"];
    [punchOnLog setObject:locationTextField.text forKey:@"location"];
    [punchOnLog setObject:commentsTextView.text forKey:@"message"];
    [punchOnLog saveInBackground];
}


#pragma mark textField delegate
- (void)textFieldFinished:(id)sender
{
     [sender resignFirstResponder];
}

#pragma mark textView delegate
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end
