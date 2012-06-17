//
//  MykiAccountInformation.h
//  shmyki
//
//  Created by Robert Wagstaff on 16/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MykiAccountInformation : NSObject

@property (nonatomic, strong) NSString* cardHolder;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, strong) NSString* cardExpiry;
@property (nonatomic, strong) NSString* cardStatus;
@property (nonatomic, strong) NSString* currentMykiMoneyBalance;
@property (nonatomic, strong) NSString* mykiMoneyTopUpInProgress;
@property (nonatomic, strong) NSString* totalMykiMoneyBalance;
@property (nonatomic, strong) NSString* currentMykiPassActive;
@property (nonatomic, strong) NSString* currentMykiPassNotYetActive;
@property (nonatomic, strong) NSString* lastMykiTransactionDate;

@property (nonatomic, strong) NSString *mykiUsername; 
@property (nonatomic, strong) NSString *mykiPassword;

-(void) saveAccountInformation;
-(void) loadAccountInformation;
@end
