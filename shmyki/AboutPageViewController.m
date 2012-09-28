//
//  AboutPageViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 9/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "AboutPageViewController.h"
#import "ShmykiContstants.h"
#import "Parse/Parse.h"
#import "GANTracker.h"
#import <QuartzCore/QuartzCore.h>


@interface AboutPageViewController ()

@end

@implementation AboutPageViewController
@synthesize twitterButton, facebookButton, webButton, feedbackButton,legalShadowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"About"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *aboutBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    [aboutBarButton setTitle:@"Back" forState:UIControlStateNormal];
    [aboutBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
    [aboutBarButton addTarget:self action:@selector(cancelAboutPage) forControlEvents:UIControlEventTouchUpInside];
    [aboutBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    
    UIBarButtonItem *aboutBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutBarButton];
    self.navigationItem.leftBarButtonItem = aboutBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
    self.legalShadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.legalShadowView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.legalShadowView.layer.shadowOpacity = .95f;
    self.legalShadowView.layer.shadowRadius = 2.5f;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"about page" withError:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark navigation

-(void) cancelAboutPage {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark IBActions
-(IBAction)twitterButtonTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"twitter://yourMyki"];
    [[UIApplication sharedApplication] openURL:url];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        url = [ [ NSURL alloc ] initWithString: @"http://twitter.com/yourMyki" ];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(IBAction)facebookButtonTapped:(id)sender {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"fb://profile/451063014917607" ];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
         url = [ [ NSURL alloc ] initWithString: @"http://www.facebook.com/pages/yourMyki/451063014917607" ];
         [[UIApplication sharedApplication] openURL:url];
    }
}

-(IBAction)webButtonTapped:(id)sender {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://yourmyki.com.au" ];
    [[UIApplication sharedApplication] openURL:url];
}

-(IBAction)rateButtonTapped:(id)sender {
    
}

-(IBAction)feedbackButtonTapped:(id)sender {
    MFMailComposeViewController *picmail = [[MFMailComposeViewController alloc] init];  
    picmail.mailComposeDelegate = self;
    [picmail setSubject:@"yourMyki Feedback"];
    [picmail setToRecipients:[NSArray arrayWithObjects:FEEDBACK_EMAIL_ADDRESS, nil]];
    [self presentModalViewController:picmail animated:YES];
}

#pragma mark MFMailCompose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
}
@end
