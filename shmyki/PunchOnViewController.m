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

@implementation PunchOnViewController
@synthesize punchOnCommentsView, punchOnCommentsTableView, listOfPunchOnLogs, totalPunchOns, helpImages, punchOnHelpImageButton, tableFixedHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.tabBarItem setTitle:@"Punch On"];
        [[self navigationItem] setTitle:APP_NAME];
        if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)] ==YES) {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"images/TabPunchOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"images/TabPunchOff"]];
        } else {
            self.tabBarItem.image = [UIImage imageNamed:@"images/TabPunchOff"];
        }
        
        UIButton *aboutBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aboutBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
        [aboutBarButton setTitle:@"about" forState:UIControlStateNormal];
        [aboutBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
        [aboutBarButton addTarget:self action:@selector(showAboutPage) forControlEvents:UIControlEventTouchUpInside];
        [aboutBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
        
        UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutBarButton];
        
        
        self.navigationItem.rightBarButtonItem = aboutBarButtonItem;
       // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"about" style:UIBarButtonItemStylePlain target:nil action:nil ];
        
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
    [self.tableFixedHeader addSubview: [TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns]];
    [self addGesturesToTableViewHeaderWithFadeEffect:NO];
    [punchOnCommentsView addGestureRecognizer:_panGestureUpRecognizerForCommentsView];
    
    self.listOfPunchOnLogs = [[PunchOnLogsCache sharedModel] loadPunchOnLogsCache];
    
    self.helpImages = [[HelpImages alloc] init];
    [self.helpImages loadHelpImageRequiredInfo];
    if (!self.helpImages.isPunchOnHelpAlreadySeen) {
        [self showPunchOnHelp];
    }
    
    self.punchOnCommentsView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.punchOnCommentsView.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    self.punchOnCommentsView.layer.shadowOpacity = .15f;
    self.punchOnCommentsView.layer.shadowRadius = 6.0f;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
   // [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    

    
 //   UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
   // hidesBackButton
 
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
   // [self.navigationItem setHidesBackButton:YES animated:YES];
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updatePunchOnLogs];
           
    [super viewDidAppear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IBActions
- (IBAction)punchOnButtonPressed:(id)sender {
    UIViewController *enterIssueViewController = [[EnterIssueViewController alloc] initWithNibName:@"EnterIssueViewController" bundle:nil];
    
    UINavigationController *enterIssueVNavController = [[UINavigationController alloc] initWithRootViewController:enterIssueViewController];
    [self.navigationController presentModalViewController:enterIssueVNavController animated:YES];
 //   [self.navigationController pushViewController:enterIssueViewController animated:YES];
}

-(IBAction)punchOnHelpTapped:(id)sender {
    [self hidePunchOnHelp];
    self.helpImages.isPunchOnHelpAlreadySeen = YES;
    [self.helpImages saveHelpImageRequiredInfo];
}

-(void) hidePunchOnHelp {

    [UIView animateWithDuration:.3 animations:^(void){
        [self.punchOnHelpImageButton setAlpha:0.0];
    }
                     completion:^(BOOL finished){[self.punchOnHelpImageButton setHidden:TRUE];}
     ];
}

-(void) showPunchOnHelp {
    [self.punchOnHelpImageButton setAlpha:0.0];
    [self.punchOnHelpImageButton setHidden:FALSE];
    [UIView animateWithDuration:.5 animations:^(void){
            [self.punchOnHelpImageButton setAlpha:1.0];
        }
    ];
}

#pragma mark about page

-(void) showAboutPage {
    UIViewController *aboutPageViewController = [[AboutPageViewController alloc] initWithNibName:@"AboutPageViewController" bundle:nil];
    
    UINavigationController *aboutPageNavController = [[UINavigationController alloc] initWithRootViewController:aboutPageViewController];
    [aboutPageNavController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController presentModalViewController:aboutPageNavController animated:YES];
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfPunchOnLogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"punchOnLogsCell";
    
    TableViewCellForPunchOnLogs *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCellForPunchOnLogs alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    PunchOnLog *punchOnLog = [listOfPunchOnLogs objectAtIndex:indexPath.row];
    cell.messageLabel.text = punchOnLog.message;
    cell.locationLabel.text = punchOnLog.location;
    cell.dateLabel.text = @"45 mins";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    PunchOnLog *punchOnLog = [listOfPunchOnLogs objectAtIndex:[indexPath row]];  
    
    CGSize constraint = CGSizeMake(320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), 40000.0f);
    
    CGSize messageLabelSize = [punchOnLog.message sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:MESSAGE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    NSString *tempDate = @"45 mins";
    CGSize dateLabelSize = [tempDate sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:LOCATION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return messageLabelSize.height + dateLabelSize.height + (CELL_CONTENT_VERTICAL_MARGIN * 2) + CELL_CONTENT_MIDDLE_MARGIN;
    
}  

#pragma mark Parse 

-(void) updatePunchOnLogs {
    PFQuery *query = [PFQuery queryWithClassName:@"PunchOnLog"];
    [query addDescendingOrder:@"createdAt"];
    // query.limit = MAX_PUNCH_ON_LOGS_RETRIEVED;
    [query findObjectsInBackgroundWithBlock:^(NSArray *punchOnLogParseObjects, NSError *error) {
        
        self.totalPunchOns = [punchOnLogParseObjects count];
        PFObject *punchOnLogParseObject;
        self.listOfPunchOnLogs = [[NSMutableArray alloc] initWithCapacity:MAX_PUNCH_ON_LOGS_RETRIEVED];
        for(int i=0; (i <[punchOnLogParseObjects count] && i < MAX_PUNCH_ON_LOGS_RETRIEVED); i++) {
            punchOnLogParseObject = [punchOnLogParseObjects objectAtIndex:i];
            PunchOnLog *punchOnLog = [[PunchOnLog alloc] init];
            [punchOnLog setMessage:[punchOnLogParseObject objectForKey:@"message"]];
            [punchOnLog setLocation:[punchOnLogParseObject objectForKey:@"location"]];
            [self.listOfPunchOnLogs addObject:punchOnLog];
        }
        [self.punchOnCommentsTableView reloadData];
        
        [(UILabel*)[[[self.tableFixedHeader.subviews objectAtIndex:0] subviews] objectAtIndex:TOTAL_PUNCH_ONS_SUBVIEW_NUMBER] setText: [NSString stringWithFormat:@"%@         ",[[NSNumber numberWithInt:totalPunchOns] stringValue]]];
        [[PunchOnLogsCache sharedModel] savePunchOnLogsCache:self.listOfPunchOnLogs];
    }];
    
}

#pragma mark gesture recognition delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer; 
{
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
            if (1==1){}
          //  NSLog(@"PAN UP %f %d",self.punchOnCommentsTableView.contentOffset.y, _punchOnCommentsViewPreTouchLocation);
            CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
            punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
            if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
            } else if (punchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
            }
            
            punchOnCommentsView.center = punchOnCommentsLocation;
            
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
            
        case UIGestureRecognizerStateChanged:
            if (1==1){}
            CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
            if (self.punchOnCommentsTableView.contentOffset.y <= 0 && translationDifferenceFromPan.y > 0 ) {
                self.punchOnCommentsTableView.scrollEnabled =NO;
                
                
                punchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
                if(punchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                } else if (punchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                    punchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
                }
                
                punchOnCommentsView.center = punchOnCommentsLocation;
            } else {
               // self.punchOnCommentsTableView.scrollEnabled =YES;
            }
            
            break;
            
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
        threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) *.33) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
    } else {
        threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) *.66) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
    }
        
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
    }
    [self panCommentsTableToLocationY: tableViewCenterLocation.y modeDidChange:shouldReplaceHeader];
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
      //  self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableUpHeaderWith:self.totalPunchOns];
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview: [TableViewHeaderHelper makeTableUpHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
    } else {
      //  self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns];
        [[[self.tableFixedHeader subviews] objectAtIndex:0] removeFromSuperview];
        [self.tableFixedHeader addSubview:[TableViewHeaderHelper makeTableDownHeaderWith:self.totalPunchOns]];
        [self addGesturesToTableViewHeaderWithFadeEffect:fadeEffect];
    }
}


-(void) addGesturesToTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCommentsTableViewUpAndDown)];
   // NSArray *tableHeaderSubViews = self.punchOnCommentsTableView.tableHeaderView.subviews;
    
    NSArray *tableHeaderSubViews = [[self.tableFixedHeader.subviews objectAtIndex:0] subviews];
    if(fadeEffect) {
        //self.punchOnCommentsTableView.tableHeaderView.alpha = 0;
        self.tableFixedHeader.alpha = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.6f];
//        self.punchOnCommentsTableView.tableHeaderView.alpha = 1;
        self.tableFixedHeader.alpha =1;
        [UIView commitAnimations];
    }
    for (UIView* tableHeaderSubView in tableHeaderSubViews) {
        if(tableHeaderSubView.tag == TAG_FOR_CLOSE_BUTTON_LABEL) {
            [tableHeaderSubView addGestureRecognizer:recognizer];
        }
    }
}



@end
