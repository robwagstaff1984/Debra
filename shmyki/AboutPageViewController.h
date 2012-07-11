//
//  AboutPageViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 9/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton* twitterButton;
@property (nonatomic, strong) IBOutlet UIButton* facebookButton;
@property (nonatomic, strong) IBOutlet UIButton* webButton;
@property (nonatomic, strong) IBOutlet UIButton* rateButton;
@property (nonatomic, strong) IBOutlet UIButton* feedbackButton;
@property (nonatomic, strong) IBOutlet UIButton* comingFeaturesButton;


-(IBAction)twitterButtonTapped:(id)sender;
-(IBAction)facebookButtonTapped:(id)sender;
-(IBAction)webButtonTapped:(id)sender;
-(IBAction)rateButtonTapped:(id)sender;
-(IBAction)feedbackButtonTapped:(id)sender;
-(IBAction)comingFeaturesButtonTapped:(id)sender;

@end
