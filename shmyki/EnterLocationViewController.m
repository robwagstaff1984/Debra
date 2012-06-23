//
//  EnterLocationViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 23/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterLocationViewController.h"

@interface EnterLocationViewController ()

@end

@implementation EnterLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                              action:@selector(savePunchOnLog)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions

-(void) savePunchOnLog {
    
}

@end
