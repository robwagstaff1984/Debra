//
//  MykiAccountInformation.m
//  shmyki
//
//  Created by Robert Wagstaff on 16/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "MykiAccountInformation.h"
#import "ShmykiContstants.h"
#import "MykiCardInformation.h"

@implementation MykiAccountInformation

- (id)init
{
    self = [super init];
    if (self) {
        self.mykiCards = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) saveAccountInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setObject:self.mykiUsername forKey:@"mykiUsername"];
    [defaults setObject:self.mykiPassword forKey:@"mykiPassword"];
    
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

    int cardNumber = 0;
    for (MykiCardInformation* mykiCard in self.mykiCards) {
        [defaults setObject:mykiCard.cardHolder forKey:[NSString stringWithFormat:@"cardHolder%d", cardNumber]];
        [defaults setObject:mykiCard.cardType forKey:[NSString stringWithFormat:@"cardType%d", cardNumber]];
        [defaults setObject:mykiCard.cardExpiry forKey:[NSString stringWithFormat:@"cardExpiry%d", cardNumber]];
        [defaults setObject:mykiCard.cardStatus forKey:[NSString stringWithFormat:@"cardStatus%d", cardNumber]];
        [defaults setObject:mykiCard.currentMykiMoneyBalance forKey:[NSString stringWithFormat:@"currentMykiMoneyBalance%d", cardNumber]];
        [defaults setObject:mykiCard.mykiMoneyTopUpInProgress forKey:[NSString stringWithFormat:@"mykiMoneyTopUpInProgress%d", cardNumber]];
        [defaults setObject:mykiCard.currentMykiPassActive forKey:[NSString stringWithFormat:@"currentMykiPassActive%d", cardNumber]];
        [defaults setObject:mykiCard.currentMykiPassNotYetActive forKey:[NSString stringWithFormat:@"currentMykiPassNotYetActive%d", cardNumber]];
        [defaults setObject:mykiCard.lastMykiTransactionDate forKey:[NSString stringWithFormat:@"lastMykiTransactionDate%d", cardNumber]];
        
        cardNumber++;
    }
    [defaults setObject:self.lastUpdatedDate forKey:@"lastUpdatedDate%d"];
    [defaults synchronize];
}

-(void) loadAccountBalanceInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL moreCardsAvailable = YES;
    int cardNumber = 0;
    while (moreCardsAvailable) {
        NSString *storedCardHolder = [defaults objectForKey:[NSString stringWithFormat:@"cardHolder%d", cardNumber]];
        NSString *storedCardType = [defaults objectForKey:[NSString stringWithFormat:@"cardType%d", cardNumber]];
        NSString *storedCardExpiry = [defaults objectForKey:[NSString stringWithFormat:@"cardExpiry%d", cardNumber]];
        NSString *storedCardStatus = [defaults objectForKey:[NSString stringWithFormat:@"cardStatus%d", cardNumber]];
        NSString *storedCurrentMykiMoneyBalance = [defaults objectForKey:[NSString stringWithFormat:@"currentMykiMoneyBalance%d", cardNumber]];
        NSString *storedMykiMoneyTopUpInProgress = [defaults objectForKey:[NSString stringWithFormat:@"mykiMoneyTopUpInProgress%d", cardNumber]];
        NSString *storedCurrentMykiPassActive = [defaults objectForKey:[NSString stringWithFormat:@"currentMykiPassActive%d", cardNumber]];
        NSString *storedCurrentMykiPassNotYetActive = [defaults objectForKey:[NSString stringWithFormat:@"currentMykiPassNotYetActive%d", cardNumber]];
        NSString *storedLastMykiTransactionDate = [defaults objectForKey:[NSString stringWithFormat:@"lastMykiTransactionDate%d", cardNumber]];

        if ([storedCardHolder length]) {
            MykiCardInformation* mykiCardInformation = [[MykiCardInformation alloc] init];
            [mykiCardInformation setCardHolder: storedCardHolder];
            [mykiCardInformation setCardType: storedCardType];
            [mykiCardInformation setCardExpiry: storedCardExpiry];
            [mykiCardInformation setCardStatus: storedCardStatus];
            [mykiCardInformation setCurrentMykiMoneyBalance: storedCurrentMykiMoneyBalance];
            [mykiCardInformation setMykiMoneyTopUpInProgress: storedMykiMoneyTopUpInProgress];
            [mykiCardInformation setCurrentMykiPassActive: storedCurrentMykiPassActive];
            [mykiCardInformation setCurrentMykiPassNotYetActive: storedCurrentMykiPassNotYetActive];
            [mykiCardInformation setLastMykiTransactionDate: storedLastMykiTransactionDate];
            [self.mykiCards addObject:mykiCardInformation];
        } else {
            moreCardsAvailable = NO;
        }
    }
    NSDate *storedLastUpdatedDate = [defaults objectForKey:@"lastUpdatedDate"];
    [self setLastUpdatedDate:storedLastUpdatedDate];
}

-(void) extractMykiAccountInfoFromHtml:(NSString*) page forCardNumber:(int)cardNumber {
    
    MykiCardInformation* mykiCardInformation = [[MykiCardInformation alloc] init];
    
    [mykiCardInformation setCardHolder:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_HOLDER]];
    [mykiCardInformation setCardType:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_TYPE]];
    [mykiCardInformation setCardExpiry:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_EXPIRY]];
    [mykiCardInformation setCardStatus:[self extractInformationFromHtml:page withRegeEx:REG_EX_CARD_STATUS]];
    [mykiCardInformation setCurrentMykiMoneyBalance:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_MONEY_BALANCE]];
    [mykiCardInformation setMykiMoneyTopUpInProgress:[self convertMykiMoneyTopUpInProgress:[self extractInformationFromHtml:page withRegeEx:REG_EX_MYKI_MONEY_TOP_UP_IN_PROGRESS]]];
    [mykiCardInformation setCurrentMykiPassActive: [self convertMykiPassActiveToDays:[self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_ACTIVE]]];
    [mykiCardInformation setCurrentMykiPassNotYetActive:[self convertMykiPassNotYetActive: [self extractInformationFromHtml:page withRegeEx:REG_EX_CURRENT_MYKI_PASS_NOT_YET_ACTIVE]]];
    [mykiCardInformation setLastMykiTransactionDate:[self extractInformationFromHtml:page withRegeEx:REG_EX_LAST_MYKI_TRANSACTION_DATE]];
    
    
    if(mykiCardInformation.cardHolder == nil && mykiCardInformation.cardExpiry ==nil && mykiCardInformation.currentMykiMoneyBalance == nil && [mykiCardInformation.currentMykiPassActive isEqualToString:@"N/A"]) {
    } else {
        [self setLastUpdatedDate:[NSDate date]];
        self.mykiCards[cardNumber] = mykiCardInformation;
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
-(NSString*)transformAccountInfoToHeaderLabelForCardNumber:(int)cardNumber {

    NSString *headerLabel = @"";
    MykiCardInformation* mykiCard = self.mykiCards[cardNumber];
    if([mykiCard.cardExpiry length] != 0) {
        headerLabel = [NSString stringWithFormat: @"Last transaction %@", mykiCard.lastMykiTransactionDate];
    } else {
        headerLabel = DEFAULT_HEADER_LABEL;
    }
    return headerLabel;
}
 
-(NSString*)transformMykiPassToMykiPassLabelForCardNumber:(int)cardNumber {
    
    NSString *mykiPassLabel =@"Days";
    MykiCardInformation* mykiCard = self.mykiCards[cardNumber];
    if([mykiCard.currentMykiPassActive length ] != 0) {
        mykiPassLabel = mykiCard.currentMykiPassActive;
    }
    return mykiPassLabel;
}

-(NSString*)transformMykiMoneyToMykiMoneyLabelForCardNumber:(int)cardNumber {
    
    NSString *mykiMoneyLabel =@"$";
    MykiCardInformation* mykiCard = self.mykiCards[cardNumber];
    if([mykiCard.currentMykiMoneyBalance length] != 0) {
        mykiMoneyLabel = mykiCard.currentMykiMoneyBalance;
    }
    return mykiMoneyLabel;
}

-(NSString*)transformAccountInfoToBottomLabelOneForCardNumber:(int)cardNumber { 
    NSString *bottomLabelOne = @"";
    MykiCardInformation* mykiCard = self.mykiCards[cardNumber];
    
    if([mykiCard.cardHolder length] != 0) {
        bottomLabelOne = [bottomLabelOne stringByAppendingString:mykiCard.cardHolder];
        if([mykiCard.cardStatus length] != 0) {
            bottomLabelOne = [bottomLabelOne stringByAppendingFormat:@" has an %@ %@ card", mykiCard.cardStatus, mykiCard.cardType];
        } 
    } else {
        bottomLabelOne = DEFAULT_BOTTOM_LABEL_ONE;
    }
    return bottomLabelOne;
}

-(NSString*)transformAccountInfoToBottomLabelTwoForCardNumber:(int)cardNumber {
    NSString *bottomLabelTwo = @"";
    MykiCardInformation* mykiCard = self.mykiCards[cardNumber];
    if([mykiCard.cardExpiry length] != 0) {
        bottomLabelTwo = [NSString stringWithFormat: @"Expires %@", mykiCard.cardExpiry];
    } else {
        bottomLabelTwo = DEFAULT_BOTTOM_LABEL_TWO;
    }
    return bottomLabelTwo;
}


@end
