//
//  MykiCardInformation.h
//  shmyki
//
//  Created by Robert Wagstaff on 11/02/13.
//  Copyright (c) 2013 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MykiCardInformation : NSObject

@property (nonatomic, strong) NSString* cardHolder;
@property (nonatomic, strong) NSString* cardType;
@property (nonatomic, strong) NSString* cardExpiry;
@property (nonatomic, strong) NSString* cardStatus;
@property (nonatomic, strong) NSString* cardIDNumber;
@property (nonatomic, strong) NSString* currentMykiMoneyBalance;
@property (nonatomic, strong) NSString* mykiMoneyTopUpInProgress;
@property (nonatomic, strong) NSString* currentMykiPassActive;
@property (nonatomic, strong) NSString* currentMykiPassNotYetActive;
@property (nonatomic, strong) NSString* lastMykiTransactionDate;

@end
