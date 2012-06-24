//
//  StationLocations.m
//  shmyki
//
//  Created by Robert Wagstaff on 24/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "StationLocations.h"
#import "ShmykiContstants.h"

@implementation StationLocations

@synthesize trainLocations, tramLocations, busLocations;

- (id)init
{
    self = [super init];
    if (self) {
        trainLocations = [[NSMutableArray alloc] init];
        tramLocations = [[NSMutableArray alloc] init];
        busLocations = [[NSMutableArray alloc] init];
        [self addTramLocations];
        [self addTrainLocations];
        [self addBusLocations];
    }
    return self;
}

-(void) addTrainLocations {
    [self.trainLocations addObject:@"A train location"];
}


-(void) addTramLocations {
    
    [self.tramLocations addObject:@"1 - East Coburg - South Melbourne Beach"];
    [self.tramLocations addObject:@"3/3a - Melbourne University - East Malvern"];
    [self.tramLocations addObject:@"5 - Melbourne University - Malvern"];
    [self.tramLocations addObject:@"6 - Melbourne University - Glen Iris"];
    [self.tramLocations addObject:@"8 - Moreland - Toorak"];
    [self.tramLocations addObject:@"11 - West Preston - Victoria Harbour Docklands"];
    [self.tramLocations addObject:@"16 - Melbourne University - Kew via St Kilda Beach"];
    [self.tramLocations addObject:@"19 - North Coburg - City Elizabeth St"];
    [self.tramLocations addObject:@"24 - North Balwyn - City (La Trobe St west end)"];
    [self.tramLocations addObject:@"30 - St Vincents Plaza - Etihad Stadium Docklands"];
    [self.tramLocations addObject:@"31 - Hoddle Street - Victoria Harbour Docklands"];
    [self.tramLocations addObject:@"35 - City Circle (Free Tourist Tram)"];
    [self.tramLocations addObject:@"48 - North Balwyn - Victoria Harbour Docklands"];
    [self.tramLocations addObject:@"55 - West Coburg - Domain Interchange"];
    [self.tramLocations addObject:@"57 - West Maribyrnong - City Elizabeth St"];
    [self.tramLocations addObject:@"59 - Airport West - City Elizabeth St"];
    [self.tramLocations addObject:@"64 - Melbourne University - East Brighton"];
    [self.tramLocations addObject:@"67 - Melbourne University - Carnegie"];
    [self.tramLocations addObject:@"70 - Waterfront City Docklands -  Wattle Park"];
    [self.tramLocations addObject:@"72 - Melbourne University - Camberwell"];
    [self.tramLocations addObject:@"75 - City (Spencer St) - Vermont South"];
    [self.tramLocations addObject:@"78 - North Richmond - Prahran"];
    [self.tramLocations addObject:@"79 - North Richmond - St Kilda Beach"];
    [self.tramLocations addObject:@"82 - Moonee Ponds - Footscray"];
    [self.tramLocations addObject:@"86 - Bundoora RMIT - Waterfront City Docklands"];
    [self.tramLocations addObject:@"95 - City (Spencer St) - Melbourne Museum"];
    [self.tramLocations addObject:@"96 - East Brunswick - St Kilda Beach"];
    [self.tramLocations addObject:@"109 - Box Hill - Port Melbourne"];
    [self.tramLocations addObject:@"112 - West Preston - St Kilda"];
    //[self.tramLocations sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


-(void) addBusLocations {
    [self.busLocations addObject:@"A bus location"];
}

-(NSInteger)getNumberOfStationsForSelectedTransport:(NSInteger)selectedTransportType {
    if(selectedTransportType == SELECTED_TRANSPORT_TRAIN) {
        return [self.trainLocations count];
    } else if(selectedTransportType == SELECTED_TRANSPORT_BUS)  {
         return [self.busLocations count];
    } else  {
         return [self.tramLocations count];
    }
}

-(NSMutableArray*)getStationsForSelectedTransport:(NSInteger)selectedTransportType {
    if(selectedTransportType == SELECTED_TRANSPORT_TRAIN) {

       
        return self.trainLocations;
    } else if(selectedTransportType == SELECTED_TRANSPORT_BUS)  {
       // [self.busLocations sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return self.busLocations ;
    } else  {
        //[self.tramLocations sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        return self.tramLocations;
    }
}

@end
