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
    punchOnCommentsTableView.userInteractionEnabled= NO;
    punchOnCommentsTableView.allowsSelection = NO;
    [self addTableViewHeader];
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
    CGPoint newPunchOnCommentsLocation = punchOnCommentsView.center;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
             _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
            break;
        
        case UIGestureRecognizerStateChanged:
            if (1==1){}

            CGPoint translationDifferenceFromPan = [sender translationInView:self.view];
            
            newPunchOnCommentsLocation.y = _punchOnCommentsViewPreTouchLocation + translationDifferenceFromPan.y;
            if(newPunchOnCommentsLocation.y < COMMENTS_ORIGIN_TO_ANCHOR_TOP) {
                newPunchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
            } else if (newPunchOnCommentsLocation.y > COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM) {
                newPunchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
            }
            
            punchOnCommentsView.center = newPunchOnCommentsLocation;
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            int threshold = ((COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM - COMMENTS_ORIGIN_TO_ANCHOR_TOP) /2) + COMMENTS_ORIGIN_TO_ANCHOR_TOP;
            if(newPunchOnCommentsLocation.y < threshold) {
                newPunchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_TOP;
                punchOnCommentsTableView.userInteractionEnabled= YES;
                [punchOnCommentsView removeGestureRecognizer:_panGestureRecognizerForCommentsView];
            } else {
                newPunchOnCommentsLocation.y = COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM;
            }
            punchOnCommentsView.center = newPunchOnCommentsLocation;

            [UIView commitAnimations];
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

-(void) addTableViewHeader {
    punchOnCommentsTableView.tableHeaderView = [TableViewHeaderHelper makeFullScreenHeaderWith:1021];
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

@end
