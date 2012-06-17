//
//  MykiAccountInformation.m
//  shmyki
//
//  Created by Robert Wagstaff on 16/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "MykiAccountInformation.h"

@implementation MykiAccountInformation

@synthesize cardHolder, cardType, cardExpiry, cardStatus, currentMykiMoneyBalance, mykiMoneyTopUpInProgress,totalMykiMoneyBalance, currentMykiPassActive,currentMykiPassNotYetActive, lastMykiTransactionDate, mykiUsername, mykiPassword;

-(void) saveAccountInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:mykiUsername forKey:@"mykiUsername"];
    [defaults setObject:mykiPassword forKey:@"mykiPassword"];
    
    [defaults synchronize];
}
-(void) loadAccountInformation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *storedMykiUsername = [defaults objectForKey:@"mykiUsername"];
    NSString *storedMykiPassword = [defaults objectForKey:@"mykiPassword"];
    
    [self setMykiUsername: storedMykiUsername];
    [self setMykiPassword: storedMykiPassword];
}

@end
