//
//  InspectorMapKitAnnotation.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "InspectorMapKitAnnotation.h"
#import "ShmykiContstants.h"
#import "DateDisplayHelper.h"


@implementation InspectorMapKitAnnotation

@synthesize coordinate, subtitle, title, spotDate, inspectorAnnotationColour, justSpotted;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    self = [super init];
    
    if (self != nil)
        coordinate = coords;
    
    return self;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@",[DateDisplayHelper getDisplayForDate:spotDate forPage:YourMykiInspectorPage]];
}

-(UIImage*) getPoiImageForTime {
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:spotDate];
    int seconds = secondsBetween / 1;

    if (seconds < SECONDS_FOR_RED_POI) {
        return [UIImage imageNamed:@"/images/IconPoiRed"];
    } else if (seconds < SECONDS_FOR_AMBER_POI) {
        return [UIImage imageNamed:@"/images/IconPoiAmber"];
    } else {
        return [UIImage imageNamed:@"/images/IconPoiBlack"];
    }
}

@end
