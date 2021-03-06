//
//  PunchOnViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterIssueViewController.h"
#import "HelpImages.h"
@class DateDisplayHelper;

@interface PunchOnViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    int _punchOnCommentsViewPreTouchLocation;
    UIPanGestureRecognizer * _panGestureUpRecognizerForCommentsView;
    UIPanGestureRecognizer * _panGestureDownRecognizerForCommentsView;
    
    BOOL _commentsTableViewIsUp;
}


@property (nonatomic, strong) IBOutlet UIView *punchOnCommentsView;
@property (nonatomic, strong) IBOutlet UITableView *punchOnCommentsTableView;
@property (nonatomic, strong) NSMutableArray *listOfPunchOnLogs;
@property (nonatomic) NSInteger totalPunchOns;
@property (nonatomic, strong) IBOutlet UIView *tableFixedHeader;
@property (nonatomic) BOOL showingCoachMarks;
@property (nonatomic, strong) HelpImages *helpImages;
@property (nonatomic, strong) IBOutlet UIImageView *punchOnCoachMarks;
@property (nonatomic, strong) DateDisplayHelper *dateDisplayHelper;


//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)updatePunchOnLogs;
- (IBAction)punchOnButtonPressed:(id)sender;
//-(IBAction)punchOnHelpTapped:(id)sender;


@end
