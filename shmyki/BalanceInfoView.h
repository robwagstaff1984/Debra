//
//  BalanceInfoView.h
//  shmyki
//
//  Created by Robert Wagstaff on 10/02/13.
//  Copyright (c) 2013 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceInfoView : UIView

@property (nonatomic, strong) UILabel* balanceMykiPassExpiryLabel;
@property (nonatomic, strong) UILabel* balanceMykiPassAdditionalLabel;
@property (nonatomic, strong) UILabel* balanceMykiMoneyAmountLabel;
@property (nonatomic, strong) UILabel* balanceMykiMoneyAdditionalLabel;

@property (nonatomic, strong) UIImageView* balanceSeperatorImage;

-(void) drawBalanceViewGradientWithCornersWithActiveState:(BOOL)isActiveState;

@end
