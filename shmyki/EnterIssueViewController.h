//
//  EnterIssueViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchOnIssues.h"


@class SA_OAuthTwitterEngine; 

@interface EnterIssueViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate> 

@property (strong, nonatomic) PunchOnIssues *punchOnIssues;
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UITableView *punchOnTableView;
@property (strong, nonatomic) IBOutlet UIView *punchOnTableViewWrapper;
@property (strong, nonatomic) IBOutlet UIView *shadowWrapper;
@property (nonatomic) BOOL punchOnIsValid;
@property (nonatomic, strong) IBOutlet UIButton* twitterButton;
@property (nonatomic, strong) IBOutlet UIButton* facebookButton;

- (IBAction)toggleTwitterButton:(id)sender;
- (IBAction)toggleFacebookButton:(id)sender; 

@end
