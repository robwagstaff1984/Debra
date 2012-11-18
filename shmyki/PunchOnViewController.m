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
#import "CustomWindow.h"

typedef enum {
    PanUpFromBottom = 1,
    PanBackToTopFromUp = 2,
    PanDownFromTop = 3,
    PanBackToDownFromBottom = 4
} PanType;

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
            if(!_commentsTableViewIsUp) {
                [(UILabel*)[[[self.tableFixedHeader.subviews objectAtIndex:0] subviews] objectAtIndex:TOTAL_PUNCH_ONS_SUBVIEW_NUMBER] setText: [NSString stringWithFormat:@"%@         ",[[NSNumber numberWithInt:totalPunchOns] stringValue]]];
            }
            self.totalPunchOns = [self.listOfPunchOnLogs count];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
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
                CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
                punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
               // NSLog(@"SDFGF %f", punchOnCommentsLocation.y);
                

                if (punchOnCommentsLocation.y > (COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM + COMMENTS_EXTRA_BOTTOM_SCROLL)) {
                    //if below myki logo, lock it there
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM + COMMENTS_EXTRA_BOTTOM_SCROLL;
                }
                
                if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                    // if above top of screen lock it there
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                }
                


                punchOnCommentsView.center = punchOnCommentsLocation;
                
                if(punchOnCommentsView.center.y <= COMMENTS_ORIGIN_TO_NAV_BAR) {
                    //if up to nav bar, move nav bar up.
                    UINavigationBar *navBar = self.navigationController.navigationBar;
                    navBar.frame = CGRectMake(navBar.frame.origin.x,
                                              20  - (COMMENTS_ORIGIN_TO_NAV_BAR - punchOnCommentsView.center.y),
                                              navBar.frame.size.width,
                                              navBar.frame.size.height);
                } else {
                    UINavigationBar *navBar = self.navigationController.navigationBar;
                    navBar.frame = CGRectMake(navBar.frame.origin.x,
                                              20,
                                              navBar.frame.size.width,
                                              navBar.frame.size.height);
                }
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
                    
                    /*punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
                    if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                    } else if (punchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
                    }
                    
                    punchOnCommentsView.center = punchOnCommentsLocation;*/
                    punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
                    //NSLog(@"SDFGF %f", punchOnCommentsLocation.y);
                    
                    if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                        //if above top of screen lock it there
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                    }
                    
                    if (punchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                        punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
                    }

                    
                    
                    
                    punchOnCommentsView.center = punchOnCommentsLocation;
                    
                   // NSLog(@"punchOnCommentsView %f", punchOnCommentsView.center.y);
                    
                    if(punchOnCommentsView.center.y >= COMMENTS_ORIGIN_TO_ANCHOR_TOP && punchOnCommentsView.center.y < COMMENTS_ORIGIN_TO_NAV_BAR) {
                        //if scrolling down from top of screen move nav bar down
                     //   NSLog(@"in here %f ", punchOnCommentsLocation.y);
                        UINavigationBar *navBar = self.navigationController.navigationBar;
                        navBar.frame = CGRectMake(navBar.frame.origin.x,
                                                  - navBar.frame.size.height + 20 + (punchOnCommentsView.center.y - COMMENTS_ORIGIN_TO_ANCHOR_TOP),
                                                  navBar.frame.size.width,
                                                  navBar.frame.size.height);
                    } else {
                        UINavigationBar *navBar = self.navigationController.navigationBar;
                        navBar.frame = CGRectMake(navBar.frame.origin.x,
                                                  20,
                                                  navBar.frame.size.width,
                                                  navBar.frame.size.height);
                    }
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
            //pan table to up state
           // tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
            shouldReplaceHeader = !_commentsTableViewIsUp;
            punchOnCommentsTableView.scrollEnabled = YES;
            
            [punchOnCommentsView addGestureRecognizer:_panGestureDownRecognizerForCommentsView];
            [punchOnCommentsView removeGestureRecognizer:_panGestureUpRecognizerForCommentsView];
            //[self panCommentsTableUpToLocationY: COMMENTS_ORIGIN_TO_ANCHOR_TOP modeDidChange:shouldReplaceHeader];
            [self panCommentsToAppropriateLocation:COMMENTS_ORIGIN_TO_ANCHOR_TOP modeDidChange:shouldReplaceHeader];
            _commentsTableViewIsUp = YES;
        } else {
            //pan table to down state
            //tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
            shouldReplaceHeader = _commentsTableViewIsUp;
            
            punchOnCommentsTableView.scrollEnabled = NO;
            [punchOnCommentsView removeGestureRecognizer:_panGestureDownRecognizerForCommentsView];
            [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];
          //  [self panCommentsTableDownToLocationY: COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM modeDidChange:shouldReplaceHeader];
            [self panCommentsToAppropriateLocation: COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM modeDidChange:shouldReplaceHeader];
            _commentsTableViewIsUp = NO;
        }
        
    }

}


-(void)panCommentsToAppropriateLocation:(int)destinationLocationY modeDidChange:(BOOL)isModeChanged{
    PanType currentPanType = [self determinPanType:destinationLocationY];


    float distanceForAnimationPartOne;
    float distanceForAnimationPartTwo;
    float totalDistanceForAnimation;
    
    float totalAnimationDuration;
    float timeForAnimationPartOne;
    float timeForAnimationPartTwo;
    
    CGPoint locationForAnimationPartOne = punchOnCommentsView.center;
    CGPoint locationForAnimationPartTwo = punchOnCommentsView.center;
    float navBarYPosition;
    
  //  NSLog(@"punchOnCommentsView.center.y %f", punchOnCommentsView.center.y );
    //    NSLog(@"destinationLocationY %d", destinationLocationY );
    UIViewAnimationCurve animationCurveOne = UIViewAnimationCurveEaseInOut;


    
    switch (currentPanType) {
        case PanUpFromBottom:
        case PanBackToTopFromUp:
            
            distanceForAnimationPartOne= punchOnCommentsView.center.y - destinationLocationY  - 44;
            distanceForAnimationPartTwo = 44;
            totalDistanceForAnimation = distanceForAnimationPartOne + distanceForAnimationPartTwo;
            if(isModeChanged) {
                 if(totalDistanceForAnimation > 130) {
                     totalAnimationDuration = 0.25f;
                 } else {
                    totalAnimationDuration = 0.12f;
                 }
            } else {
                totalAnimationDuration = 0.4f;
            }
            
            
    
            timeForAnimationPartOne = (distanceForAnimationPartOne / totalDistanceForAnimation) * totalAnimationDuration;
            timeForAnimationPartTwo = (distanceForAnimationPartTwo / totalDistanceForAnimation) * totalAnimationDuration;
            
            locationForAnimationPartOne.y = destinationLocationY  + 44;
            locationForAnimationPartTwo.y = destinationLocationY;
            navBarYPosition = -24;
            
            //if only partially back up
            if(distanceForAnimationPartOne < 0) {
                distanceForAnimationPartOne = 0;
                timeForAnimationPartOne = 0;
                timeForAnimationPartTwo = totalAnimationDuration;
                locationForAnimationPartOne.y = punchOnCommentsView.center.y;
            }
            
            break;
            
        case PanDownFromTop:
        case PanBackToDownFromBottom:
            
            distanceForAnimationPartOne= punchOnCommentsView.center.y - destinationLocationY;
            totalDistanceForAnimation = distanceForAnimationPartOne + 0;

            if(isModeChanged) {
                if(totalDistanceForAnimation < -100) {
                    totalAnimationDuration = 0.25f;
                } else {
                    totalAnimationDuration = 0.12f;
                }
            } else {
                totalAnimationDuration = 0.4f;
            }
            
            //NSLog(@"totalDistanceForAnimation %f", distanceForAnimationPartOne);
            timeForAnimationPartOne = totalAnimationDuration;
            timeForAnimationPartTwo = 0;
            
            locationForAnimationPartOne.y = destinationLocationY;
            locationForAnimationPartTwo.y = destinationLocationY;
            navBarYPosition= 20;
         //   animationCurveOne = UIViewAnimationCurveEaseInOut;
            
            break;
        default:
            break;
    }
  
    
    
//
//    NSLog(@"distanceForAnimationPartOne %f",distanceForAnimationPartOne);
//    NSLog(@"distanceForAnimationPartTwo %f",distanceForAnimationPartTwo);
//    NSLog(@"destinationLocationY %d",destinationLocationY);
//    NSLog(@"locationForAnimationPartOne.y: %f",locationForAnimationPartOne.y);
//    NSLog(@"locationForAnimationPartTwo.y: %f",locationForAnimationPartTwo.y);
//    NSLog(@"timeForAnimationPartOne: %f",timeForAnimationPartOne);
//    NSLog(@"timeForAnimationPartTwo: %f",timeForAnimationPartTwo);
    
    
    [UIView animateWithDuration:timeForAnimationPartOne delay:0.0 options:animationCurveOne animations:^{        
        punchOnCommentsView.center = locationForAnimationPartOne;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeForAnimationPartTwo delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
            punchOnCommentsView.center = locationForAnimationPartTwo;
            self.navigationController.navigationBar.frame = CGRectMake(0,navBarYPosition,320,44);
        } completion:^(BOOL finished) {
            /*if(navBarYPosition == -24) {
                [(CustomWindow*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] setInterceptEvents:YES];
            } else {
                [(CustomWindow*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] setInterceptEvents:NO];
            }*/
            
            if (isModeChanged) {
                [self toggleTableViewHeaderWithFadeEffect:YES];
            }
        }];
    }];

}

-(PanType) determinPanType:(int)destinationLocationY {
    PanType currentPanType;
    if(destinationLocationY == COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
        if(_commentsTableViewIsUp) {
            currentPanType = PanBackToTopFromUp;
        } else {
            currentPanType = PanUpFromBottom;
        }
    } else if (destinationLocationY == COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
        if(_commentsTableViewIsUp) {
            currentPanType = PanDownFromTop;
        } else {
            currentPanType = PanBackToDownFromBottom;
        }
    }
    //NSLog(@"current Pan type: %d", currentPanType);
    return currentPanType;
}

- (void)toggleCommentsTableViewUpAndDown
{
    if(_commentsTableViewIsUp)  {
        _commentsTableViewIsUp = NO;
        self.punchOnCommentsTableView.scrollEnabled = NO;
        [self panCommentsToAppropriateLocation:COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM modeDidChange:YES];
        [punchOnCommentsView removeGestureRecognizer:_panGestureDownRecognizerForCommentsView];
        [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];

    } else {
        _commentsTableViewIsUp = YES;
        self.punchOnCommentsTableView.scrollEnabled = YES;
        [self panCommentsToAppropriateLocation:COMMENTS_ORIGIN_TO_ANCHOR_TOP modeDidChange:YES];
        [punchOnCommentsView addGestureRecognizer:_panGestureDownRecognizerForCommentsView];
        [punchOnCommentsView removeGestureRecognizer:_panGestureUpRecognizerForCommentsView];
    }
}

-(void) toggleTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    if(_commentsTableViewIsUp) {
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview: [TableViewHeaderHelper makeTableUpHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
        
       // [self.navigationItem setRightBarButtonItem:nil animated:NO];
        //[self.navigationItem setLeftBarButtonItem:[YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Add" withTarget:self withAction:@selector(punchOnButtonPressed:)] animated:NO];

    } else {
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview:[TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
        
      //  [self.navigationItem setLeftBarButtonItem:nil animated:NO];
       // [self.navigationItem setRightBarButtonItem:[YourMykiCustomButton createYourMykiBarButtonItemWithText:@"About" withTarget:self withAction:@selector(showAboutPage)] animated:NO];
    }
}


-(void) addGesturesToTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCommentsTableViewUpAndDown)];
    
    NSArray *tableHeaderSubViews = [[self.tableFixedHeader.subviews objectAtIndex:0] subviews];
    
    [self.tableFixedHeader setBackgroundColor:[UIColor blueColor]];
    
    for (UIView* tableHeaderSubView in tableHeaderSubViews) {
            [tableHeaderSubView setBackgroundColor:[UIColor greenColor]];
        if(tableHeaderSubView.tag == TAG_FOR_CLOSE_BUTTON_LABEL) {
            [tableHeaderSubView setBackgroundColor:[UIColor purpleColor]];
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
