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


@end
