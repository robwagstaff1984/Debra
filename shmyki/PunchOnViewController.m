//
//  PunchOnViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnViewController.h"
#import "EnterIssueViewController.h"
#import "AboutPageViewController.h"
#import "ShmykiContstants.h"
#import "Parse/Parse.h"
#import "PunchOnLog.h"
#import "TableViewCellForPunchOnLogs.h"
#import "TableViewHeaderHelper.h"
#import "PunchOnLogsCache.h"
#import "HelpImages.h"
#import "AppDelegate.h"
#import "YourMykiCustomButton.h"
#import "DateDisplayHelper.h"
#import "FeatureToggle.h"
#import "GANTracker.h"
#import <QuartzCore/QuartzCore.h>
#import "DateDisplayHelper.h"

@implementation PunchOnViewController
@synthesize punchOnCommentsView, punchOnCommentsTableView, listOfPunchOnLogs, totalPunchOns, tableFixedHeader, helpImages, punchOnCoachMarks, showingCoachMarks, dateDisplayHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.tabBarItem setTitle:@"yourVoice"];
        [[self navigationItem] setTitle:APP_NAME];
        if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)] ==YES) {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"images/TabPunchOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"images/TabPunchOff"]];
        } else {
            self.tabBarItem.image = [UIImage imageNamed:@"images/TabPunchOff"];
        }
        
        self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"About" withTarget:self withAction:@selector(showAboutPage)];
        dateDisplayHelper = [[DateDisplayHelper alloc] init];
        self.listOfPunchOnLogs = [[NSMutableArray alloc] initWithCapacity:MAX_PUNCH_ON_LOGS_RETRIEVED];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _panGestureUpRecognizerForCommentsView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomUpPan:)];
    _panGestureUpRecognizerForCommentsView.delegate = self;
    
    _panGestureDownRecognizerForCommentsView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomDownPan:)];
    _panGestureDownRecognizerForCommentsView.delegate = self;
    
    self.punchOnCommentsTableView.scrollEnabled =NO;
    self.punchOnCommentsTableView.allowsSelection = NO;
    //self.punchOnCommentsTableView.tableHeaderView.userInteractionEnabled = YES;
    //self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns];
    self.listOfPunchOnLogs = [[PunchOnLogsCache sharedModel] loadPunchOnLogsCache];
    self.totalPunchOns = [self.listOfPunchOnLogs count];
    [self.tableFixedHeader addSubview: [TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns]];
    [self addGesturesToTableViewHeaderWithFadeEffect:NO];
    [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];
    

    
    self.helpImages = [[HelpImages alloc] init];
    [self.helpImages loadHelpImageRequiredInfo];
    
    //   self.helpImages.isPunchOnHelpAlreadySeen = NO;
    if (!self.helpImages.isPunchOnHelpAlreadySeen && FEATURE_PUNCH_ON_COACH_MARKS) {
        [self showPunchOnCoachMarks];
        [self hidePunchOnCoachMarksWithDelay:4.0 WithDuration:2.0];
        self.helpImages.isPunchOnHelpAlreadySeen = YES;
        [self.helpImages saveHelpImageRequiredInfo];
    }
    
    self.punchOnCommentsView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.punchOnCommentsView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    self.punchOnCommentsView.layer.shadowOpacity = .15f;
    self.punchOnCommentsView.layer.shadowRadius = 6.0f;
    [self fadeInTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"yourVoice" withError:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
   // [self.navigationItem setHidesBackButton:YES animated:YES];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updatePunchOnLogs];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)punchOnButtonPressed:(id)sender {
    UIViewController *enterIssueViewController = [[EnterIssueViewController alloc] initWithNibName:@"EnterIssueViewController" bundle:nil];
    
    UINavigationController *enterIssueVNavController = [[UINavigationController alloc] initWithRootViewController:enterIssueViewController];
    [self.navigationController presentModalViewController:enterIssueVNavController animated:YES];
    //   [self.navigationController pushViewController:enterIssueViewController animated:YES];
}


-(void) fadeInTableView {
    self.punchOnCommentsTableView.alpha = 0.0;
    self.punchOnCommentsView.alpha = 0.0;

    [UIView animateWithDuration:0.9 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        self.punchOnCommentsTableView.alpha = 1.0;
        self.punchOnCommentsView.alpha = 1.0;
    } completion:^(BOOL finished){

    }];

}

#pragma mark about page

-(void) showAboutPage {
    UIViewController *aboutPageViewController = [[AboutPageViewController alloc] initWithNibName:@"AboutPageViewController" bundle:nil];
    
    [self.navigationController pushViewController:aboutPageViewController animated:YES];
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfPunchOnLogs count];
}

//trying out a quicker way. works but bugs with updating
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    
    TableViewCellForPunchOnLogs *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCellForPunchOnLogs alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        PunchOnLog *punchOnLog = [listOfPunchOnLogs objectAtIndex:indexPath.row];
        cell.messageLabel.text = punchOnLog.message;
        cell.locationLabel.text = punchOnLog.location;
        cell.dateLabel.text = [DateDisplayHelper getDisplayForDate:punchOnLog.dateLogged forPage:YourMykiPunchOnPage];
        
        switch (punchOnLog.transportationType) {
            case SELECTED_TRANSPORT_TRAM:
                [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconTram"]];
                break;
            case SELECTED_TRANSPORT_TRAIN:
                [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconTrain"]];
                break;
            case SELECTED_TRANSPORT_BUS:
                [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconBus"]];
                break;
            default:
                [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconComment"]];
        }
    }
    
    
    
    //cell.layer.shouldRasterize = YES;
  //  cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"punchOnLogsCell";
    
    TableViewCellForPunchOnLogs *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCellForPunchOnLogs alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PunchOnLog *punchOnLog = [listOfPunchOnLogs objectAtIndex:indexPath.row];
    cell.messageLabel.text = punchOnLog.message;
    cell.locationLabel.text = punchOnLog.location;
    cell.dateLabel.text = [dateDisplayHelper getDisplayForDate:punchOnLog.dateLogged forPage:YourMykiPunchOnPage];
    cell.messageLabelHeight = punchOnLog.messageLabelHeight;

    switch (punchOnLog.transportationType) {
        case SELECTED_TRANSPORT_TRAM:
            [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconTram"]];
            break;
        case SELECTED_TRANSPORT_TRAIN:
            [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconTrain"]];
            break;
        case SELECTED_TRANSPORT_BUS:
            [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconBus"]];
            break;
        default:
            [cell.locationIconLabel setImage:[UIImage imageNamed:@"/images/IconComment"]];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{    
    return [[listOfPunchOnLogs objectAtIndex:[indexPath row]] cellHeight];
    
}  

#pragma mark Parse 

-(void) updatePunchOnLogs {
    PFQuery *query = [PFQuery queryWithClassName:@"PunchOnLog"];
    [query addDescendingOrder:@"createdAt"];
    // query.limit = MAX_PUNCH_ON_LOGS_RETRIEVED;
    [query findObjectsInBackgroundWithBlock:^(NSArray *punchOnLogParseObjects, NSError *error) {
        
        if(error == nil) {
            
            [self getCurrentCountOfPunchOns];
            PFObject *punchOnLogParseObject;
            self.listOfPunchOnLogs = [[NSMutableArray alloc] initWithCapacity:MAX_PUNCH_ON_LOGS_RETRIEVED];

            
            for(int i=0; (i <[punchOnLogParseObjects count] && i < MAX_PUNCH_ON_LOGS_RETRIEVED); i++) {
                punchOnLogParseObject = [punchOnLogParseObjects objectAtIndex:i];
                PunchOnLog *punchOnLog = [[PunchOnLog alloc] init];
                [punchOnLog setMessage:[punchOnLogParseObject objectForKey:@"message"]];
                [punchOnLog setLocation:[punchOnLogParseObject objectForKey:@"location"]];
                [punchOnLog setDateLogged:punchOnLogParseObject.createdAt];
                [punchOnLog setTransportationType:[[punchOnLogParseObject objectForKey:@"transportationType"] integerValue]];
                [self.listOfPunchOnLogs addObject:punchOnLog];
            }

            [[PunchOnLogsCache sharedModel] savePunchOnLogsCache:self.listOfPunchOnLogs];
        }
        
        self.listOfPunchOnLogs = [[PunchOnLogsCache sharedModel] loadPunchOnLogsCache];
        [self.punchOnCommentsTableView reloadData];
    }];

    
    self.listOfPunchOnLogs = [[PunchOnLogsCache sharedModel] loadPunchOnLogsCache];
    self.totalPunchOns = [self.listOfPunchOnLogs count];
    [self.punchOnCommentsTableView reloadData];
    
}

-(void) getCurrentCountOfPunchOns {
    PFQuery *query = [PFQuery queryWithClassName:@"PunchOnLog"];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            self.totalPunchOns = count;
            if(!_commentsTableViewIsUp) {
                [(UILabel*)[[[self.tableFixedHeader.subviews objectAtIndex:0] subviews] objectAtIndex:TOTAL_PUNCH_ONS_SUBVIEW_NUMBER] setText: [NSString stringWithFormat:@"%@         ",[[NSNumber numberWithInt:self.totalPunchOns] stringValue]]];
            }
        }
    }];
}

#pragma mark gesture recognition delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer; 
{
    //if (_commentsTableViewIsUp) {
      //  return NO;
   // }
    return YES;
}

#pragma mark custom pans
- (void)handleCustomUpPan:(UIPanGestureRecognizer *)sender {

    CGPoint punchOnCommentsLocation = punchOnCommentsView.center;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
            break;
            
        case UIGestureRecognizerStateChanged:
            {
              //  NSLog(@"PAN UP %f %d",self.punchOnCommentsTableView.contentOffset.y, _punchOnCommentsViewPreTouchLocation);
                CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
                punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
                if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                } else if (punchOnCommentsLocation.y > (COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM + COMMENTS_EXTRA_BOTTOM_SCROLL)) {
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM + COMMENTS_EXTRA_BOTTOM_SCROLL;
                }
                
                punchOnCommentsView.center = punchOnCommentsLocation;
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            
            [self panCommentsTableViewToAppropriateStateForLocation:punchOnCommentsLocation];
            
            
            break;
            
        default:
            break;
    } 
}

- (void)handleCustomDownPan:(UIPanGestureRecognizer *)sender { 
    
    CGPoint punchOnCommentsLocation = punchOnCommentsView.center;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
            break;
            
        case UIGestureRecognizerStateChanged: {
            

            if (self.punchOnCommentsTableView.contentOffset.y <= 0) {
                CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
                if(translationDifferenceFromPan.y > 0 ) {
                    self.punchOnCommentsTableView.scrollEnabled =NO;
                    
                    punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
                    if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                    } else if (punchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
                    }
                    
                    punchOnCommentsView.center = punchOnCommentsLocation;
                }
            }
            
            
            break;
            
        }
        case UIGestureRecognizerStateEnded:
            
            [self panCommentsTableViewToAppropriateStateForLocation:punchOnCommentsLocation];
            
            
            break;
            
        default:
            break;
    } 

}

#pragma mark Punch On Table effects Helper Methods 

-(void) panCommentsTableViewToAppropriateStateForLocation:(CGPoint)tableViewCenterLocation{
    int threshold;
    if (_commentsTableViewIsUp){
        threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) *.20) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
    } else {
        threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) *.80) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
    }
        

    if(tableViewCenterLocation.y != COMMENTS_ORIGIN_TO_ANCHOR_TOP || !_commentsTableViewIsUp) {
        
        int shouldReplaceHeader = YES;
        if(tableViewCenterLocation.y < threshold) {
            tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
            shouldReplaceHeader = !_commentsTableViewIsUp;
            punchOnCommentsTableView.scrollEnabled = YES;
            _commentsTableViewIsUp = YES;
            [punchOnCommentsView addGestureRecognizer:_panGestureDownRecognizerForCommentsView];
            [punchOnCommentsView removeGestureRecognizer:_panGestureUpRecognizerForCommentsView];
            
            
        } else {
            tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
            shouldReplaceHeader = _commentsTableViewIsUp;
            _commentsTableViewIsUp = NO;
            punchOnCommentsTableView.scrollEnabled = NO;
            [punchOnCommentsView removeGestureRecognizer:_panGestureDownRecognizerForCommentsView];
            [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];
           // [self panCommentsTableToLocationY: tableViewCenterLocation.y modeDidChange:shouldReplaceHeader];
        }
        [self panCommentsTableToLocationY: tableViewCenterLocation.y modeDidChange:shouldReplaceHeader];
    }

}

-(void) panCommentsTableToLocationY:(int)locationY modeDidChange:(BOOL)isModeChanged{
    
    float animationDuration;
    int distance =  punchOnCommentsView.center.y - locationY;
    if (distance < 0 ) {
        distance = -1 * distance;
    }
    if(isModeChanged) {
        if(distance > 100) {
            animationDuration = .25f;
        } else {
             animationDuration = .1f;
        }
    } else {
        animationDuration = .4f;
    }
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:animationDuration];
    CGPoint panToLocation = punchOnCommentsView.center;
    panToLocation.y = locationY;
    punchOnCommentsView.center = panToLocation;
    [UIView commitAnimations];
    
    if(isModeChanged) {
        [self toggleTableViewHeaderWithFadeEffect:YES];
    }

}

- (void)toggleCommentsTableViewUpAndDown
{
    if(_commentsTableViewIsUp)  {
        _commentsTableViewIsUp = NO;
        self.punchOnCommentsTableView.scrollEnabled = NO;
        [self panCommentsTableToLocationY:COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM modeDidChange:YES];
        [punchOnCommentsView removeGestureRecognizer:_panGestureDownRecognizerForCommentsView];
        [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];

    } else {
        _commentsTableViewIsUp = YES;
        self.punchOnCommentsTableView.scrollEnabled = YES;
        [self panCommentsTableToLocationY:COMMENTS_ORIGIN_TO_ANCHOR_TOP modeDidChange:YES];
        [punchOnCommentsView addGestureRecognizer:_panGestureDownRecognizerForCommentsView];
        [punchOnCommentsView removeGestureRecognizer:_panGestureUpRecognizerForCommentsView];
    }
}

-(void) toggleTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    if(_commentsTableViewIsUp) {
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview: [TableViewHeaderHelper makeTableUpHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
        
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
        [self.navigationItem setLeftBarButtonItem:[YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Add" withTarget:self withAction:@selector(punchOnButtonPressed:)] animated:NO];

    } else {
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview:[TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
        
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        [self.navigationItem setRightBarButtonItem:[YourMykiCustomButton createYourMykiBarButtonItemWithText:@"About" withTarget:self withAction:@selector(showAboutPage)] animated:NO];
    }
}


-(void) addGesturesToTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCommentsTableViewUpAndDown)];
    
    NSArray *tableHeaderSubViews = [[self.tableFixedHeader.subviews objectAtIndex:0] subviews];
    
    for (UIView* tableHeaderSubView in tableHeaderSubViews) {
        if(tableHeaderSubView.tag == TAG_FOR_CLOSE_BUTTON_LABEL) {
            [tableHeaderSubView addGestureRecognizer:recognizer];
        }
    }
    
    if(fadeEffect) {
        
        for (UIView* tableHeaderSubView in tableHeaderSubViews) {
            if(tableHeaderSubView.tag != TAG_FOR_TABLE_HEADER_LABEL) {
                tableHeaderSubView.alpha = 0;
            }
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.6f];
        
        for (UIView* tableHeaderSubView in tableHeaderSubViews) {
            if(tableHeaderSubView.tag != TAG_FOR_TABLE_HEADER_LABEL) {
                tableHeaderSubView.alpha = 1;
            }
        }
        [UIView commitAnimations];
    }
}


#pragma mark coach marks

/*-(IBAction)punchOnHelpTapped:(id)sender {
    [self hidePunchOnHelp];
    self.helpImages.isPunchOnHelpAlreadySeen = YES;
    [self.helpImages saveHelpImageRequiredInfo];
}*/

/*-(void) hidePunchOnHelp {
    
    [UIView animateWithDuration:.3 animations:^(void){
        [self.punchOnHelpImageButton setAlpha:0.0];
    }
                     completion:^(BOOL finished){[self.punchOnHelpImageButton setHidden:TRUE];}
     ];
    [self showPunchOnCoachMarks];
    [self hidePunchOnCoachMarksWithDelay:3.0 WithDuration:2.0];
    
}

-(void) showPunchOnHelp {
    [self.punchOnHelpImageButton setAlpha:0.0];
    [self.punchOnHelpImageButton setHidden:FALSE];
    [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        [self.punchOnHelpImageButton setAlpha:1.0];
    } completion:nil];
    
}*/

-(void) hidePunchOnCoachMarksWithDelay:(float) delay WithDuration:(float) duration{
    
   // [self.punchOnHelpImageButton setHidden:FALSE];
    //  [self.punchOnCoachMarks setAlpha:1.0];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        [self.punchOnCoachMarks setAlpha:0.0];
    } completion:^(BOOL finished){
        self.showingCoachMarks = NO;
        // [self.punchOnCoachMarks setHidden:TRUE];
    }];
}

-(void) showPunchOnCoachMarks {
    
    [self.punchOnCoachMarks setHidden:FALSE];
    [self.punchOnCoachMarks setAlpha:1.0];
    self.showingCoachMarks = YES;
    //    [self.punchOnCoachMarks setAlpha:0.0];
    //    [self.punchOnCoachMarks setHidden:FALSE];
    //    self.showingCoachMarks = YES;
    //    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
    //        [self.punchOnCoachMarks setAlpha:1.0];
    //    } completion:nil];
    
}

@end
