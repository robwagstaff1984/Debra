//
//  InspectorMapKitAnnotation.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "InspectorMapKitAnnotation.h"

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
    
    if(seconds < 60) {
        displayTitle = [NSString stringWithFormat:@"just now", seconds];
    } else if (seconds < 3600) {
        displayTitle = [NSString stringWithFormat:@"%d minutes ago", (seconds / 60)];
    } else if (seconds < 86400) {
         displayTitle = [NSString stringWithFormat:@"%d hours ago", (seconds / 3600)];
    } else if (seconds < 604800) {
         displayTitle = [NSString stringWithFormat:@"%d days ago", (seconds / 86400)];
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
