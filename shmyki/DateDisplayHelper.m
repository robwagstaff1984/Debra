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



+(NSString*) getDisplayForDate:(NSDate*)date forPage:(YourMykiPage) yourMykiPage {
    
    NSString* dateDisplay;
   // NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
  //  int seconds = secondsBetween / 1;
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval secondsBetween = [currentTime timeIntervalSinceDate:date];
    int seconds = [[NSNumber numberWithDouble:secondsBetween] intValue];
    
    if(currentTime == nil) return nil;
    
    if(seconds < SECONDS_IN_A_MINUTE) {
        dateDisplay = [NSString stringWithFormat:@"just now", seconds];
    } else if (seconds < SECONDS_IN_AN_HOUR) {
        dateDisplay = [NSString stringWithFormat:@"%d minutes ago", (seconds / SECONDS_IN_A_MINUTE)];
    } else if (seconds < SECONDS_IN_AN_DAY) {
        dateDisplay = [NSString stringWithFormat:@"%d hours ago", (seconds / SECONDS_IN_AN_HOUR)];
    } else if (seconds < SECONDS_IN_AN_WEEK) {
        dateDisplay = [NSString stringWithFormat:@"%d days ago", (seconds / SECONDS_IN_AN_DAY)];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMM dd hh:mm a";     
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; 
        dateDisplay =  [dateFormatter stringFromDate:date];
    }
    return dateDisplay;
}



@end
