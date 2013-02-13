//
//  StationLocations.h
//  shmyki
//
//  Created by Robert Wagstaff on 24/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationLocations : NSObject

@property (nonatomic,strong) NSMutableArray *trainLocations;
@property (nonatomic,strong) NSMutableArray *tramLocations;
@property (nonatomic,strong) NSMutableArray *busLocations;


-(NSInteger)getNumberOfStationsForSelectedTransport:(NSInteger)selectedTransportType;
-(NSMutableArray*)getStationsForSelectedTransport:(NSInteger)selectedTransportType;
-(NSMutableArray*)getAllStationsForAllTransportTypes;
-(NSInteger) getTransportationTypeForStation:(NSString*)station;
@end
