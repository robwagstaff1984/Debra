//
//  PunchOnViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnViewController.h"
#import "EnterIssueViewController.h"


@implementation PunchOnViewController

@synthesize enterIssueViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Punch On", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TabPunchOff"];
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

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark IBActions
- (IBAction)punchOnButtonPressed:(id)sender {
   // UIViewController *enterIssueViewController = [[EnterIssueViewController alloc] initWithNibName:@"sEnterIssueViewController" bundle:nil];
    
    
   // [self.view addSubview:enterIssueViewController.view];
   // 
    /*[UIView transitionWithView:self.view 
                      duration:2 
                       options:UIViewAnimationTransitionCurlUp //any animation
                    animations:^ {[self.view addSubview:enterIssueViewController.view]; }
                    completion:nil];*/
    
   // 
    
   // [self presentModalViewController:enterIssueViewController animated:YES];

//    [enterIssueViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
  //  [self presentViewController:enterIssueViewController animated:YES completion:nil];

    
    
    [self.navigationController pushViewController:enterIssueViewController animated:YES];
}


@end
