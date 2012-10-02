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

@synthesize cardHolder, cardType, cardExpiry, cardStatus, currentMykiMoneyBalance, mykiMoneyTopUpInProgress,totalMykiMoneyBalance, currentMykiPassActive,currentMykiPassNotYetActive, lastMykiTransactionDate, mykiUsername, mykiPassword, lastUpdatedDate;

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

-(void) saveAccountBalanceInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:cardHolder forKey:@"cardHolder"];
    [defaults setObject:cardType forKey:@"cardType"];
    [defaults setObject:cardExpiry forKey:@"cardExpiry"];
    [defaults setObject:cardStatus forKey:@"cardStatus"];
    [defaults setObject:currentMykiMoneyBalance forKey:@"currentMykiMoneyBalance"];
    [defaults setObject:mykiMoneyTopUpInProgress forKey:@"mykiMoneyTopUpInProgress"];
    [defaults setObject:currentMykiPassActive forKey:@"currentMykiPassActive"];
    [defaults setObject:currentMykiPassNotYetActive forKey:@"currentMykiPassNotYetActive"];
    [defaults setObject:lastMykiTransactionDate forKey:@"lastMykiTransactionDate"];
    [defaults setObject:lastUpdatedDate forKey:@"lastUpdatedDate"];
    
    [defaults synchronize];

}

-(void) loadAccountBalanceInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *storedCardHolder = [defaults objectForKey:@"cardHolder"];
    NSString *storedCardType = [defaults objectForKey:@"cardType"];
    NSString *storedCardExpiry = [defaults objectForKey:@"cardExpiry"];
    NSString *storedCardStatus = [defaults objectForKey:@"cardStatus"];
    NSString *storedCurrentMykiMoneyBalance = [defaults objectForKey:@"currentMykiMoneyBalance"];
    NSString *storedMykiMoneyTopUpInProgress = [defaults objectForKey:@"mykiMoneyTopUpInProgress"];
    NSString *storedCurrentMykiPassActive = [defaults objectForKey:@"currentMykiPassActive"];
    NSString *storedCurrentMykiPassNotYetActive = [defaults objectForKey:@"currentMykiPassNotYetActive"];
    NSString *storedLastMykiTransactionDate = [defaults objectForKey:@"lastMykiTransactionDate"];
    NSDate *storedLastUpdatedDate = [defaults objectForKey:@"lastUpdatedDate"];

    [self setCardHolder: storedCardHolder];
    [self setCardType: storedCardType];
    [self setCardExpiry: storedCardExpiry];
    [self setCardStatus: storedCardStatus];
    [self setCurrentMykiMoneyBalance: storedCurrentMykiMoneyBalance];
    [self setMykiMoneyTopUpInProgress: storedMykiMoneyTopUpInProgress];
    [self setCurrentMykiPassActive: storedCurrentMykiPassActive];
    [self setCurrentMykiPassNotYetActive: storedCurrentMykiPassNotYetActive];
    [self setLastMykiTransactionDate: storedLastMykiTransactionDate];
    [self setLastUpdatedDate: storedLastUpdatedDate];
}

-(void) extractMykiAccountInfoFromHtml:(NSString*) page {

    [self setCardHolder:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_HOLDER]];
    [self setCardType:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_TYPE]];
    [self setCardExpiry:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_EXPIRY]];
    [self setCardStatus:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_STATUS]];
    [self setCurrentMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_MONEY_BALANCE]];
    [self setMykiMoneyTopUpInProgress:[self convertMykiMoneyTopUpInProgress:[self extractInformationFromHtml:page withRegeEx:REG_EX_MYKI_MONEY_TOP_UP_IN_PROGRESS]]];
    //[self setTotalMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_TOTAL_MYKI_MONEY_BALANCE]];
    [self setCurrentMykiPassActive: [self convertMykiPassActiveToDays:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE]]];
    [self setCurrentMykiPassNotYetActive:[self convertMykiPassNotYetActive: [self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_NOT_YET_ACTIVE]]];
    [self setLastMykiTransactionDate:[self extractInformationFromHtml:page withRegeEx:REG_EX_LAST_MYKI_TRANSACTION_DATE]];
    
    
    if(self.cardHolder == nil && self.cardExpiry ==nil && self.currentMykiMoneyBalance == nil && [self.currentMykiPassActive isEqualToString:@"N/A"]) {
        //NSLog(@"DONT UPDATE");
    } else {
        //NSLog(@"UPDATED STUFF");
        [self setLastUpdatedDate:[NSDate date]];
        [self saveAccountBalanceInformation];
    }
}

-(BOOL)isLoginUnsuccessful:(NSString*)page {

    NSRange isSessionExpiredProblemRange = [page rangeOfString:ERROR_SESSION_EXPIRED options:NSCaseInsensitiveSearch];
    NSRange isCredentialsProblemRange = [page rangeOfString:ERROR_404 options:NSCaseInsensitiveSearch];
    NSRange is404PageProblemRange = [page rangeOfString:ERROR_CREDENTIALS options:NSCaseInsensitiveSearch];
    
    if(isSessionExpiredProblemRange.length !=0 || isCredentialsProblemRange.length !=0 || is404PageProblemRange.length !=0) {
        return YES;
    }
    return NO;
    
}

-(BOOL)isProblemWithCredentials:(NSString*)page {
    
    NSRange isRange = [page rangeOfString:ERROR_CREDENTIALS options:NSCaseInsensitiveSearch];
    return isRange.length != 0;
}

-(NSString*) convertMykiPassActiveToDays:(NSString*)currentMykiPassActiveRaw {
    NSString* currentMykiPassActiveDateString =@"N/A";
    
    if([currentMykiPassActiveRaw length] != 0 ) {
        
        currentMykiPassActiveDateString = [self extractInformationFromHtml:currentMykiPassActiveRaw withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE_IN_DAYS];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateFormat:@"dd MMM yyyy hh:mm:ss a"];
        NSDate *currentMykiPassActiveDate = [dateFormatter dateFromString:currentMykiPassActiveDateString];
        if(currentMykiPassActiveDate != nil) {
            NSTimeInterval secondsTillExpiry = [[NSDate date] timeIntervalSinceDate:currentMykiPassActiveDate];
            int daysTillMykiExpiry = ((secondsTillExpiry / SECONDS_IN_AN_DAY) - 1) * -1;
            currentMykiPassActiveDateString = [NSString stringWithFormat:@"%d Days", daysTillMykiExpiry];
        }
    }
    return currentMykiPassActiveDateString;
}

-(NSString*) convertMykiPassNotYetActive:(NSString*)mykiPassNotYetActiveRaw  {
    NSString *mykiPassNotYetActiveConverted = @"";

    if ([mykiPassNotYetActiveRaw length] != 0 && ![mykiPassNotYetActiveRaw isEqualToString:@" "]) {
        NSRange range = [mykiPassNotYetActiveRaw rangeOfString:@","];
        NSString *days = [NSString stringWithString :[mykiPassNotYetActiveRaw substringToIndex:range.location] ];
        mykiPassNotYetActiveConverted = [NSString stringWithFormat:@"%@not yet active", days];
    }
    return mykiPassNotYetActiveConverted;
}

-(NSString*) convertMykiMoneyTopUpInProgress:(NSString*)mykiMoneyTopUpInProgressRaw  {
    if([mykiMoneyTopUpInProgressRaw isEqualToString:@"$0.00"] || [mykiMoneyTopUpInProgressRaw length] ==0  || [mykiMoneyTopUpInProgressRaw isEqualToString:@" "]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@ in progress", mykiMoneyTopUpInProgressRaw];
    }
}

-(NSString*) extractInformationFromHtml:(NSString*) page withRegeEx: (NSString*) regExString {
    NSError *error;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regExString options:0 error:&error];
    NSTextCheckingResult *result = [regEx firstMatchInString:page options:0 range:NSMakeRange(0, [page length])];
    if(result == nil) {
        return nil;
    } else {
        return [page substringWithRange:[result rangeAtIndex:1]];
    }
}


#pragma mark transform account info to labels
-(NSString*)transformAccountInfoToHeaderLabel {

    NSString *headerLabel = @"";
    if([cardExpiry length] != 0) {
        headerLabel = [NSString stringWithFormat: @"Last transaction %@", lastMykiTransactionDate];
    } else {
        headerLabel = DEFAULT_HEADER_LABEL;
    }
    return headerLabel;
}
 
-(NSString*)transformMykiPassToMykiPassLabel {
    
    NSString *mykiPassLabel =@"Days";
    if([currentMykiPassActive length ] != 0) {
        mykiPassLabel = currentMykiPassActive;
    }
    return mykiPassLabel;
}

-(NSString*)transformMykiMoneyToMykiMoneyLabel {
    
    NSString *mykiMoneyLabel =@"$";
    if([currentMykiMoneyBalance length] != 0) {
        mykiMoneyLabel = currentMykiMoneyBalance;
    }
    return mykiMoneyLabel;
}

-(NSString*)transformAccountInfoToBottomLabelOne {
    NSString *bottomLabelOne = @"";
    if([cardHolder length] != 0) {
        bottomLabelOne = [bottomLabelOne stringByAppendingString:cardHolder];
        if([cardStatus length] != 0) {
            bottomLabelOne = [bottomLabelOne stringByAppendingFormat:@" has an %@ %@ card", cardStatus, cardType];
        } 
    } else {
        bottomLabelOne = DEFAULT_BOTTOM_LABEL_ONE;
    }
    return bottomLabelOne;
}

-(NSString*)transformAccountInfoToBottomLabelTwo {
    NSString *bottomLabelTwo = @"";
    if([cardExpiry length] != 0) {
        bottomLabelTwo = [NSString stringWithFormat: @"Expires %@", cardExpiry];
    } else {
        bottomLabelTwo = DEFAULT_BOTTOM_LABEL_TWO;
    }
    return bottomLabelTwo;
}


@end
