//
//  EnterIssueViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchOnIssues.h"

@interface EnterIssueViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PunchOnIssues *punchOnIssues;
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UITableView *punchOnTableView;
@property (nonatomic) BOOL facebookIsSelected;
@property (nonatomic) BOOL twitterIsSelected;
@property (nonatomic) BOOL punchOnIsValid;

- (IBAction)toggleTwitterButton:(id)sender;
- (IBAction)toggleFacebookButton:(id)sender; 

@end
