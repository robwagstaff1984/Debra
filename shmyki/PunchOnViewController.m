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



@implementation PunchOnViewController
@synthesize punchOnCommentsView, punchOnCommentsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setTitle:@"Punch On"];
        [[self navigationItem] setTitle:APP_NAME];
        self.tabBarItem.image = [UIImage imageNamed:@"images/TabPunchOff"];
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
    
    UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomPan:)];
    recognizer.delegate = self;
    [punchOnCommentsView addGestureRecognizer:recognizer];
     [punchOnCommentsView addGestureRecognizer:recognizer];
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
    UITouch *touch = [[event allTouches] anyObject];
    
   // if( [touch view] == punchOnCommentsView)
 //   {
       // CGPoint touchLocation = [touch locationInView:self.view];
       // NSLog(@"original %f", touchLocation.y);
        _punchOnCommentsViewPreTouchLocation = punchOnCommentsView.center.y;
  //  }
    [super touchesBegan:touches withEvent:event];
}

- (void)handleCustomPan:(UIPanGestureRecognizer *)sender { 
    CGPoint newPunchOnCommentsLocation = punchOnCommentsView.center;
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            if (1==1)
            {

            }
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"punchOnLogsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
   // cell.textLabel.text = [object objectForKey:@"message"];
 //   cell.detailTextLabel.text = [NSString stringWithFormat:@"Location: %@", [object objectForKey:@"location"]];
    cell.textLabel.text = @"rob";
    return cell;
}

@end
