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
    return [NSString stringWithFormat:@"Rob"];
}

@end
