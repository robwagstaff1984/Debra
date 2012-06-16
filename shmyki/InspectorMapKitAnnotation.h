//
//  InspectorMapKitAnnotation.h
//  shmyki
//
//  Created by Robert Wagstaff on 11/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface InspectorMapKitAnnotation : NSObject <MKAnnotation> 


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, strong) NSDate *spotDate;
@property (nonatomic) NSUInteger inspectorAnnotationColour;
@property (nonatomic) BOOL justSpotted;


- (id)initWithCoords:(CLLocationCoordinate2D) coords;
- (UIImage*) getPoiImageForTime;
@end
