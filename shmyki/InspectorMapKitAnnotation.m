//
//  InspectorMapKitAnnotation.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "InspectorMapKitAnnotation.h"
#import "ShmykiContstants.h"


@implementation InspectorMapKitAnnotation

@synthesize coordinate, subtitle, title, spotDate;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    self = [super init];
    
    if (self != nil)
        coordinate = coords;
    
    return self;
}

- (NSString *)title
{
    
    NSString *displayTitle;
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:spotDate];
    int seconds = secondsBetween / 1;
    
    if(seconds < SECONDS_IN_A_MINUTE) {
        displayTitle = [NSString stringWithFormat:@"just now", seconds];
    } else if (seconds < SECONDS_IN_AN_HOUR) {
        displayTitle = [NSString stringWithFormat:@"%d minutes ago", (seconds / SECONDS_IN_A_MINUTE)];
    } else if (seconds < SECONDS_IN_AN_DAY) {
         displayTitle = [NSString stringWithFormat:@"%d hours ago", (seconds / SECONDS_IN_AN_HOUR)];
    } else if (seconds < SECONDS_IN_AN_WEEK) {
         displayTitle = [NSString stringWithFormat:@"%d days ago", (seconds / SECONDS_IN_AN_DAY)];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; 
        displayTitle =  [dateFormatter stringFromDate:[NSDate date]];
    }
    
    return displayTitle;
}

@end
