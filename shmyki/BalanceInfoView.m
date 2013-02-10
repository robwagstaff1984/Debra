//
//  BalanceInfoView.m
//  shmyki
//
//  Created by Robert Wagstaff on 10/02/13.
//  Copyright (c) 2013 DWS Limited. All rights reserved.
//

#import "BalanceInfoView.h"

@implementation BalanceInfoView

@synthesize balanceMykiMoneyAdditionalLabel, balanceMykiMoneyAmountLabel, balanceMykiPassExpiryLabel, balanceMykiPassAdditionalLabel;

- (id)init
{
    self = [super init];
    if (self) {
        self.balanceMykiPassExpiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 141, 38)];
        self.balanceMykiPassExpiryLabel.text = @"Days";
        [self.balanceMykiPassExpiryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
        [self.balanceMykiPassExpiryLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
        [self.balanceMykiPassExpiryLabel setShadowOffset:CGSizeMake(0, 1.0)];
        self.balanceMykiPassExpiryLabel.textColor = [UIColor whiteColor];
        self.balanceMykiPassExpiryLabel.textAlignment = UITextAlignmentCenter;
        
        self.balanceMykiPassAdditionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, 141, 21)];
        [self.balanceMykiPassAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
        self.balanceMykiPassAdditionalLabel.textColor = [UIColor whiteColor];
        self.balanceMykiPassAdditionalLabel.textAlignment = UITextAlignmentCenter;
        
        self.balanceMykiMoneyAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, 32, 141, 38)];
        self.balanceMykiMoneyAmountLabel.text = @"$";
        [self.balanceMykiMoneyAmountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f]];
        [self.balanceMykiMoneyAmountLabel setShadowColor:[UIColor colorWithHue:.587222 saturation:.1313888 brightness:.198333 alpha:1]];
        [self.balanceMykiMoneyAmountLabel setShadowOffset:CGSizeMake(0, 1.0)];
        self.balanceMykiMoneyAmountLabel.textColor = [UIColor whiteColor];
        self.balanceMykiMoneyAmountLabel.textAlignment = UITextAlignmentCenter;
        
        self.balanceMykiMoneyAdditionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, 72, 141, 21)];
        [self.balanceMykiMoneyAdditionalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
        self.balanceMykiMoneyAdditionalLabel.textColor = [UIColor whiteColor];
        self.balanceMykiMoneyAdditionalLabel.textAlignment = UITextAlignmentCenter;
        
        
        [self addSubview:self.balanceMykiPassExpiryLabel];
        [self addSubview:self.balanceMykiMoneyAmountLabel];
        [self addSubview:self.balanceMykiMoneyAdditionalLabel];
        [self addSubview:self.balanceMykiPassAdditionalLabel];
    }
    return self;
}



@end
