//
//  BalanceInfoView.m
//  shmyki
//
//  Created by Robert Wagstaff on 10/02/13.
//  Copyright (c) 2013 DWS Limited. All rights reserved.
//

#import "BalanceInfoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BalanceInfoView

@synthesize balanceMykiMoneyAdditionalLabel, balanceMykiMoneyAmountLabel, balanceMykiPassExpiryLabel, balanceMykiPassAdditionalLabel;

@synthesize balanceSeperatorImage;

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDynamicLabels];
        [self setupStaticLabels];
    }
    return self;
}


-(void) setupDynamicLabels {
    self.balanceMykiPassExpiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 141, 38)];
    self.balanceMykiPassExpiryLabel.text = @"Days";
    [self.balanceMykiPassExpiryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
    [self.balanceMykiPassExpiryLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
    [self.balanceMykiPassExpiryLabel setShadowOffset:CGSizeMake(0, 1.0)];
    self.balanceMykiPassExpiryLabel.textColor = [UIColor whiteColor];
    self.balanceMykiPassExpiryLabel.textAlignment = UITextAlignmentCenter;
    self.balanceMykiPassExpiryLabel.backgroundColor = [UIColor clearColor];
    
    self.balanceMykiPassAdditionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 72, 141, 21)];
    [self.balanceMykiPassAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    self.balanceMykiPassAdditionalLabel.textColor = [UIColor whiteColor];
    self.balanceMykiPassAdditionalLabel.textAlignment = UITextAlignmentCenter;
    self.balanceMykiPassAdditionalLabel.backgroundColor = [UIColor clearColor];
    
    self.balanceMykiMoneyAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(159, 32, 141, 38)];
    self.balanceMykiMoneyAmountLabel.text = @"$";
    [self.balanceMykiMoneyAmountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
    [self.balanceMykiMoneyAmountLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
    [self.balanceMykiMoneyAmountLabel setShadowOffset:CGSizeMake(0, 1.0)];
    self.balanceMykiMoneyAmountLabel.textColor = [UIColor whiteColor];
    self.balanceMykiMoneyAmountLabel.textAlignment = UITextAlignmentCenter;
    self.balanceMykiMoneyAmountLabel.backgroundColor = [UIColor clearColor];
    
    self.balanceMykiMoneyAdditionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(159, 72, 141, 21)];
    [self.balanceMykiMoneyAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    self.balanceMykiMoneyAdditionalLabel.textColor = [UIColor whiteColor];
    self.balanceMykiMoneyAdditionalLabel.textAlignment = UITextAlignmentCenter;
    self.balanceMykiMoneyAdditionalLabel.backgroundColor = [UIColor clearColor];
    
    self.balanceSeperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(159, 12, 2, 75)];
    self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLine.png"];
    
    [self addSubview:self.balanceMykiPassExpiryLabel];
    [self addSubview:self.balanceMykiMoneyAmountLabel];
    [self addSubview:self.balanceMykiMoneyAdditionalLabel];
    [self addSubview:self.balanceMykiPassAdditionalLabel];
           
    [self addSubview:self.balanceSeperatorImage];
}

-(void) setupStaticLabels {
    
    UILabel* mykiPassHeading = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 141, 25)];
    mykiPassHeading.text = @"myki pass expiry";
    [mykiPassHeading setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    mykiPassHeading.textColor = [UIColor whiteColor];
    mykiPassHeading.textAlignment = UITextAlignmentCenter;
    mykiPassHeading.backgroundColor = [UIColor clearColor];
    
    UILabel* mykiMoneyHeading = [[UILabel alloc] initWithFrame:CGRectMake(159, 5, 141, 25)];
    mykiMoneyHeading.text = @"myki money";
    [mykiMoneyHeading setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    mykiMoneyHeading.textColor = [UIColor whiteColor];
    mykiMoneyHeading.textAlignment = UITextAlignmentCenter;
    mykiMoneyHeading.backgroundColor = [UIColor clearColor];
    
    [self addSubview:mykiPassHeading];
    [self addSubview:mykiMoneyHeading];
}

-(void) drawBalanceViewGradientWithCornersWithActiveState:(BOOL)isActiveState {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(20, 0, 280, 100);
    UIColor *startColour;
    UIColor *endColour;
    if(isActiveState) {
        startColour = [UIColor colorWithHue:0.5833 saturation:0.50 brightness:0.62 alpha:1.0];
        endColour = [UIColor colorWithHue:0.5833 saturation:0.35 brightness:0.88 alpha:1.0];
        self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLine.png"];
    } else {
        startColour = [UIColor colorWithHue:0.0 saturation:0.00 brightness:0.45 alpha:1.0];
        endColour = [UIColor colorWithHue:0.0 saturation:0.00 brightness:0.70 alpha:1.0];
        self.balanceSeperatorImage.image = [UIImage imageNamed:@"images/BalanceLineBlk.png"];
    }
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    self.layer.cornerRadius = 10;
    gradient.cornerRadius = 10;
    [self.layer insertSublayer:gradient atIndex:0];
}




@end
