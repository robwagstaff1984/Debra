//
//  PunchOnViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterIssueViewController.h"

@interface PunchOnViewController : UIViewController <UIGestureRecognizerDelegate> {
    int _punchOnCommentsViewPreTouchLocation;
}


@property (nonatomic, strong) IBOutlet UIView *punchOnCommentsView;

- (IBAction)punchOnButtonPressed:(id)sender;
//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)handleCustomPan:(UIPanGestureRecognizer *)sender;

@end
