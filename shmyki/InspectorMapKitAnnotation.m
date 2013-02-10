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

@synthesize coordinate, subtitle, title, spotDate, inspectorAnnotationColour, justSpotted, dateDisplayHelper, spotType;

- (id)initWithCoords:(CLLocationCoordinate2D) coords spotType:(NSString*)spotTypePin {
    self = [super init];
    
    if (self != nil) {
        coordinate = coords;
        dateDisplayHelper = [[DateDisplayHelper alloc] init];
        spotType = spotTypePin;
    }
    return self;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@",[dateDisplayHelper getDisplayForDate:spotDate forPage:YourMykiInspectorPage]];
}

-(UIImage*) getPoiImageForTime {
    
    
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:spotDate];
    int seconds = secondsBetween / 1;
    
    if (seconds < SECONDS_FOR_RED_POI) {
        if([self.spotType isEqualToString:@"DISTURBANCE"]) {
            return [UIImage imageNamed:@"/images/PoiRedDisturb"];
        } else if([self.spotType isEqualToString:@"POLICE"]){
            return [UIImage imageNamed:@"/images/PoiRedPolice"];
        } else {
            return [UIImage imageNamed:@"/images/PoiRedInspector"];
        }
    } else if (seconds < SECONDS_FOR_AMBER_POI) {
        if([self.spotType isEqualToString:@"DISTURBANCE"]) {
            return [UIImage imageNamed:@"/images/PoiOrangeDisturb"];
        } else if([self.spotType isEqualToString:@"POLICE"]){
            return [UIImage imageNamed:@"/images/PoiOrangePolice"];
        } else {
            return [UIImage imageNamed:@"/images/PoiOrangeInspector"];
        }
    } else {
        if([self.spotType isEqualToString:@"DISTURBANCE"]) {
            return [UIImage imageNamed:@"/images/PoiBlackDisturb"];
        } else if([self.spotType isEqualToString:@"POLICE"]){
            return [UIImage imageNamed:@"/images/PoiBlackPolice"];
        } else {
            return [UIImage imageNamed:@"/images/PoiBlackInspector"];
        }
    }
    
}

@end
