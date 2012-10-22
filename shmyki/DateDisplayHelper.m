//
//  DateDisplayHelper.m
//  shmyki
//
//  Created by Robert Wagstaff on 10/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "DateDisplayHelper.h"
#import "ShmykiContstants.h"

@implementation DateDisplayHelper

@synthesize dateFormatter;

- (id)init
{
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

-(NSString*) getDisplayForDate:(NSDate*)date forPage:(YourMykiPage) yourMykiPage {
    
    NSString* dateDisplay;
   // NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
  //  int seconds = secondsBetween / 1;
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval secondsBetween = [currentTime timeIntervalSinceDate:date];
    int seconds = [[NSNumber numberWithDouble:secondsBetween] intValue];
    NSString* plural=@"s";
    
    if(currentTime == nil) return nil;
    
    if(seconds < SECONDS_IN_A_MINUTE) {
        dateDisplay = [NSString stringWithFormat:@"just now"];
    } else if (seconds < SECONDS_IN_AN_HOUR) {
        if( (seconds / SECONDS_IN_A_MINUTE) == 1) {
            plural = @"";
        }
        dateDisplay = [NSString stringWithFormat:@"%d minute%@ ago", (seconds / SECONDS_IN_A_MINUTE),plural];
    } else if (seconds < SECONDS_IN_AN_DAY) {
        if( (seconds / SECONDS_IN_AN_HOUR) == 1) {
            plural = @"";
        }
        dateDisplay = [NSString stringWithFormat:@"%d hour%@ ago", (seconds / SECONDS_IN_AN_HOUR), plural];
    } else if (seconds < SECONDS_IN_AN_WEEK) {
        if( (seconds / SECONDS_IN_AN_DAY) == 1) {
            plural = @"";
        }
        dateDisplay = [NSString stringWithFormat:@"%d day%@ ago", (seconds / SECONDS_IN_AN_DAY), plural];
    } else {
        dateFormatter.dateFormat = @"MMM dd hh:mm a";     
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; 
        dateDisplay =  [dateFormatter stringFromDate:date];
    }
    return dateDisplay;
}



@end
