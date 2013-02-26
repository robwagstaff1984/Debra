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
@property (nonatomic, strong) UIButton *topUpDisclaimer;

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
    self.topUpDisclaimer = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topUpDisclaimer.frame = CGRectMake(0, 0, 320, 416);
    [self.topUpDisclaimer addTarget:self action:@selector(dismissWarning) forControlEvents:UIControlEventTouchUpInside];
    [self.topUpDisclaimer setBackgroundImage:[UIImage imageNamed:@"images/TopupDisclaimer.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.topUpDisclaimer];
	// Do any additional setup after loading the view.
}

-(void)backTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) dismissWarning {
    [UIView animateWithDuration:0.5 animations:^{
        self.topUpDisclaimer.alpha = 0;
    }];
}

@end
