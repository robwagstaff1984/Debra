//
//  MykiAccountInformation.m
//  shmyki
//
//  Created by Robert Wagstaff on 16/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "MykiAccountInformation.h"
#import "ShmykiContstants.h"

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

//-(void)setCurrentMykiPassActive:(NSString *)currentMykiPassActiveToSet {
//    NSLog(currentMykiPassActiveToSet);
//    currentMykiPassActive = currentMykiPassActiveToSet;
//}
 
-(void) extractMykiAccountInfoFromHtml:(NSString*) page {

    [self setCardHolder:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_HOLDER]];
    [self setCardType:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_TYPE]];
    [self setCardExpiry:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_EXPIRY]];
    [self setCardStatus:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_STATUS]];
    [self setCurrentMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_MONEY_BALANCE]];
    [self setMykiMoneyTopUpInProgress:[self convertMykiMoneyTopUpInProgress:[self extractInformationFromHtml:page withRegeEx:REG_EX_MYKI_MONEY_TOP_UP_IN_PROGRESS]]];
    [self setTotalMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_TOTAL_MYKI_MONEY_BALANCE]];
    
    [self setCurrentMykiPassActive: [self convertMykiPassActiveToDays:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE]]];
    [self setCurrentMykiPassNotYetActive:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_NOT_YET_ACTIVE]];
    [self setLastMykiTransactionDate:[self extractInformationFromHtml:page withRegeEx:REG_EX_LAST_MYKI_TRANSACTION_DATE]];
}

-(NSString*) convertMykiPassActiveToDays:(NSString*)currentMykiPassActiveRaw {
    NSString* currentMykiPassActiveDateString = [self extractInformationFromHtml:currentMykiPassActiveRaw withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE_IN_DAYS];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd MMM yyyy hh:mm:ss a"];
    NSDate *currentMykiPassActiveDate = [dateFormatter dateFromString:currentMykiPassActiveDateString];
    if(currentMykiPassActiveDate != nil) {
         NSTimeInterval secondsTillExpiry = [[NSDate date] timeIntervalSinceDate:currentMykiPassActiveDate];
        int daysTillMykiExpiry = ((secondsTillExpiry / SECONDS_IN_AN_DAY) - 1) * -1;
        currentMykiPassActiveDateString = [NSString stringWithFormat:@"%d Days", daysTillMykiExpiry];
    } else {
        currentMykiPassActiveDateString =@"N/A";
    }
    return currentMykiPassActiveDateString;
}

-(NSString*) convertMykiMoneyTopUpInProgress:(NSString*)mykiMoneyTopUpInProgressRaw  {
    if([mykiMoneyTopUpInProgress isEqualToString:@"$0.00"]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@ in progress", mykiMoneyTopUpInProgressRaw];
    }
}

-(NSString*) extractInformationFromHtml:(NSString*) page withRegeEx: (NSString*) regExString {
    NSError *error;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regExString options:0 error:&error];
    NSTextCheckingResult *result = [regEx firstMatchInString:page options:0 range:NSMakeRange(0, [page length])];
    return [page substringWithRange:[result rangeAtIndex:1]];
}



@end
