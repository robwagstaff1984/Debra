//
//  TopUpWebViewViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 21/02/13.
//  Copyright (c) 2013 DWS Limited. All rights reserved.
//

#import "TopUpWebViewViewController.h"
#import "YourMykiCustomButton.h"

@interface TopUpWebViewViewController ()

@end

@implementation TopUpWebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Myki Card Top Up"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(backTapped:)];
    [self.navigationItem setHidesBackButton:YES];
	// Do any additional setup after loading the view.
}

-(void)backTapped:(id)sender {

    [self dismissModalViewControllerAnimated:YES];
}

@end
