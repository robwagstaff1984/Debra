//
//  PunchOnViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnViewController.h"
#import "EnterIssueViewController.h"
#import "ShmykiContstants.h"
#import "Parse/Parse.h"
#import "PunchOnLog.h"
#import "TableViewCellForPunchOnLogs.h"
#import "TableViewHeaderHelper.h"

@implementation PunchOnViewController
@synthesize punchOnCommentsView, punchOnCommentsTableView, listOfPunchOnLogs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setTitle:@"Punch On"];
        [[self navigationItem] setTitle:APP_NAME];
        self.tabBarItem.image = [UIImage imageNamed:@"images/TabPunchOff"];
        self.listOfPunchOnLogs = [[NSMutableArray alloc] initWithCapacity:MAX_PUNCH_ON_LOGS_RETRIEVED];
        [self updatePunchOnLogs];
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
    
    _panGestureRecognizerForCommentsView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomPan:)];
    _panGestureRecognizerForCommentsView.delegate = self;
    //self.punchOnCommentsTableView.userInteractionEnabled= NO;
    self.punchOnCommentsTableView.scrollEnabled =NO;
    self.punchOnCommentsTableView.allowsSelection = NO;
    self.punchOnCommentsTableView.tableHeaderView.userInteractionEnabled = YES;
    self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableDownHeader];
    [self addGesturesToTableViewHeaderWithFadeEffect:NO];
    [punchOnCommentsView addGestureRecognizer:_panGestureRecognizerForCommentsView];
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
- (IBAction)punchOnButtonPressed:(id)sender {
    UIViewController *enterIssueViewController = [[EnterIssueViewController alloc] initWithNibName:@"EnterIssueViewController" bundle:nil];

    [self.navigationController pushViewController:enterIssueViewController animated:YES];
}

#pragma mark gesture recognition delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
    [super touchesBegan:touches withEvent:event];
}

- (void)handleCustomPan:(UIPanGestureRecognizer *)sender { 
    CGPoint punchOnCommentsLocation = punchOnCommentsView.center;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
             _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
            break;
        
        case UIGestureRecognizerStateChanged:
            if (1==1){}

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

#pragma tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfPunchOnLogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"punchOnLogsCell";
    
    TableViewCellForPunchOnLogs *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCellForPunchOnLogs alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
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
    
    CGSize messageLabelSize = [punchOnLog.message sizeWithFont:[UIFont systemFontOfSize:MESSAGE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    NSString *tempDate = @"45 mins";
    CGSize dateLabelSize = [tempDate sizeWithFont:[UIFont systemFontOfSize:LOCATION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return messageLabelSize.height + dateLabelSize.height + (CELL_CONTENT_VERTICAL_MARGIN * 3);
    
}  

#pragma mark Parse 

-(void) updatePunchOnLogs {
    PFQuery *query = [PFQuery queryWithClassName:@"PunchOnLog"];
    [query addDescendingOrder:@"createdAt"];
    query.limit = MAX_PUNCH_ON_LOGS_RETRIEVED;
    [query findObjectsInBackgroundWithBlock:^(NSArray *punchOnLogParseObjects, NSError *error) {
        
        PFObject *punchOnLogParseObject;
        for(int i=0; i <[punchOnLogParseObjects count]; i++) {
            punchOnLogParseObject = [punchOnLogParseObjects objectAtIndex:i];
            PunchOnLog *punchOnLog = [[PunchOnLog alloc] init];
            [punchOnLog setMessage:[punchOnLogParseObject objectForKey:@"message"]];
            [punchOnLog setLocation:[punchOnLogParseObject objectForKey:@"location"]];
            [self.listOfPunchOnLogs addObject:punchOnLog];
        }
        [punchOnCommentsTableView reloadData];
    }];

}

#pragma mark Helper Methods 

-(void) panCommentsTableViewToAppropriateStateForLocation:(CGPoint)tableViewCenterLocation{
    int threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) /2) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
    if(tableViewCenterLocation.y < threshold) {
        tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
        punchOnCommentsTableView.scrollEnabled = YES;
        _commentsTableViewIsUp = YES;
        [punchOnCommentsView removeGestureRecognizer:_panGestureRecognizerForCommentsView];
    } else {
        tableViewCenterLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
        _commentsTableViewIsUp = NO;
        punchOnCommentsTableView.scrollEnabled = NO;
    }
    [self panCommentsTableToLocationY: tableViewCenterLocation.y];
}

-(void) panCommentsTableToLocationY:(int)locationY {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGPoint panToLocation = punchOnCommentsView.center;
    panToLocation.y = locationY;
    punchOnCommentsView.center = panToLocation;
    //   self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableUpHeaderWith:1021];
    self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableDownHeader];
    [UIView commitAnimations];

}

- (void)toggleCommentsTableViewUpAndDown:(UITapGestureRecognizer *)recognizer
{
    if(_commentsTableViewIsUp)  {
        _commentsTableViewIsUp = NO;
        self.punchOnCommentsTableView.scrollEnabled = NO;
        [self panCommentsTableToLocationY:COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM];
        [self.punchOnCommentsView addGestureRecognizer:_panGestureRecognizerForCommentsView];
        [self toggleTableViewHeader];
    } else {
        _commentsTableViewIsUp = YES;
        self.punchOnCommentsTableView.scrollEnabled = YES;
        [self panCommentsTableToLocationY:COMMENTS_ORIGIN_TO_ANCHOR_TOP];
        [self.punchOnCommentsView removeGestureRecognizer:_panGestureRecognizerForCommentsView];
        [self toggleTableViewHeader];
    }
}

-(void) toggleTableViewHeader {
    
    if(_commentsTableViewIsUp) {
        self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableUpHeaderWith:1021];
        [self addGesturesToTableViewHeaderWithFadeEffect:YES];
    } else {
        self.punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeTableDownHeader];
        [self addGesturesToTableViewHeaderWithFadeEffect:YES];
    }
}


-(void) addGesturesToTableViewHeaderWithFadeEffect:(BOOL)fadeEffect {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCommentsTableViewUpAndDown:)];
    NSArray *tableHeaderSubViews = self.punchOnCommentsTableView.tableHeaderView.subviews;

    if(fadeEffect) {
        self.punchOnCommentsTableView.tableHeaderView.alpha = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.6f];
        self.punchOnCommentsTableView.tableHeaderView.alpha = 1;
        [UIView commitAnimations];
    }
    for (UIView* tableHeaderSubView in tableHeaderSubViews) {
        if(tableHeaderSubView.tag == TAG_FOR_CLOSE_BUTTON_LABEL) {
            [tableHeaderSubView addGestureRecognizer:recognizer];
        }
    }
}


@end
