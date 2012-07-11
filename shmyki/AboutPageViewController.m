//
//  AboutPageViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 9/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "AboutPageViewController.h"

@interface AboutPageViewController ()

@end

@implementation AboutPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *aboutBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    [aboutBarButton setTitle:@"cancel" forState:UIControlStateNormal];
    [aboutBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
    [aboutBarButton addTarget:self action:@selector(cancelAboutPage) forControlEvents:UIControlEventTouchUpInside];
    [aboutBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    
    UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutBarButton];
    self.navigationItem.rightBarButtonItem = aboutBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
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

#pragma mark navigation

-(void) cancelAboutPage {
    
    /*[UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
    NSViewAnimation*/
    [self.navigationController popViewControllerAnimated:YES];
   // [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
   // [self dismissModalViewControllerAnimated:YES];
}

@end
