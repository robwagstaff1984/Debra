//
//  ComingFeaturesViewControllerViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "ComingFeaturesViewController.h"
#import "ShmykiContstants.h"

@interface ComingFeaturesViewController ()

@end

@implementation ComingFeaturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:APP_NAME];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIButton *aboutBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    [aboutBarButton setTitle:@"Back" forState:UIControlStateNormal];
    [aboutBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
    [aboutBarButton addTarget:self action:@selector(cancelAboutComingPage) forControlEvents:UIControlEventTouchUpInside];
    [aboutBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    
    UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutBarButton];
    self.navigationItem.leftBarButtonItem = aboutBarButtonItem;
    

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

-(void) cancelAboutComingPage {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
