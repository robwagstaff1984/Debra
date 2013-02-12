//
//  MykiAccountInformation.h
//  shmyki
//
//  Created by Robert Wagstaff on 16/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MykiAccountInformation : NSObject

@property (nonatomic, strong) NSMutableArray* mykiCards;
@property (nonatomic, strong) NSString *mykiUsername; 
@property (nonatomic, strong) NSString *mykiPassword;
@property (nonatomic, strong) NSDate* lastUpdatedDate;

-(void) saveAccountInformation;
-(void) loadAccountInformation;
-(void) saveAccountBalanceInformation;
-(void) loadAccountBalanceInformation;
-(void) extractMykiAccountInfoFromHtml:(NSString*) page forCardNumber:(int)cardNumber;
-(BOOL) isLoginUnsuccessful:(NSString*)page;
-(BOOL) isProblemWithCredentials:(NSString*)page;

-(NSString*)transformAccountInfoToHeaderLabelOneForCardNumber:(int)cardNumber;
-(NSString*)transformAccountInfoToHeaderLabelTwoForCardNumber:(int)cardNumber;

-(NSString*)transformMykiPassToMykiPassLabelForCardNumber:(int)cardNumber;
-(NSString*)transformMykiMoneyToMykiMoneyLabelForCardNumber:(int)cardNumber;

-(NSString*)transformMykiMoneyTopUpInProgressToLabelForCardNumber:(int)cardNumber;
-(NSString*)transformCurrentMykiPassNotYetActiveToLabelForCardNumber:(int)cardNumber;


-(NSString*)transformAccountInfoToBottomLabelOneForCardNumber:(int)cardNumber;
-(NSString*)transformAccountInfoToBottomLabelTwoForCardNumber:(int)cardNumber;

@end
