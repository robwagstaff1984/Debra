//
//  PunchOnLogsCache.m
//  shmyki
//
//  Created by Robert Wagstaff on 4/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnLogsCache.h"
#import "PunchOnLog.h"

@implementation PunchOnLogsCache


static PunchOnLogsCache *sharedObject = nil;

+(id)sharedModel{
    @synchronized(self) {
        if(sharedObject == nil){
            sharedObject = [[super alloc] init];
        }
    }
    return sharedObject;
}


-(void) savePunchOnLogsCache:(NSMutableArray*)cachedPunchOnLogs {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cachedPunchOnLogs];
    [defaults setObject: data forKey:@"cachedPunchOnLogs"];
    [defaults synchronize];
}


-(NSMutableArray*) loadPunchOnLogsCache {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"cachedPunchOnLogs"];
    NSMutableArray *cachedPunchOnLogs;
    if (data != nil) {
        cachedPunchOnLogs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if([cachedPunchOnLogs count] == 0) {
        cachedPunchOnLogs = [self createDefaultPunchOnLogCache];
    }
    return cachedPunchOnLogs;
}

-(NSMutableArray*) createDefaultPunchOnLogCache {
    NSMutableArray *defaultCachedPunchOnLogs = [[NSMutableArray alloc] init];
    NSDate *now = [NSDate date];
    
    PunchOnLog *punchOnLogOne = [[PunchOnLog alloc] init];
    PunchOnLog *punchOnLogTwo = [[PunchOnLog alloc] init];
    PunchOnLog *punchOnLogThree = [[PunchOnLog alloc] init];
    
    
    [punchOnLogOne setMessage:@"Ahhhh, Myki is so frustrating! I miss metcards :("];
   // [punchOnLog setLocation:@"Melbourne Central"];
   // [punchOnLog setTransportationType:2];
    [punchOnLogOne setDateLogged:[now dateByAddingTimeInterval:60*60*24*1]];
    [defaultCachedPunchOnLogs addObject:punchOnLogOne];
    
    [punchOnLogTwo setMessage:@"So packed on the team I couldn't get to the machine, what could I do?"];
    [punchOnLogTwo setLocation:@"109"];
    [punchOnLogTwo setTransportationType:0];
    [punchOnLogTwo setDateLogged:[now dateByAddingTimeInterval:60*60*24*2]];
    [defaultCachedPunchOnLogs addObject:punchOnLogTwo];
    
    [punchOnLogThree setMessage:@"I don't see what all the fuss is about. I think myki is great"];
    [punchOnLogThree setLocation:@"Melbourne Central"];
    [punchOnLogThree setTransportationType:1];
    [punchOnLogThree setDateLogged:[now dateByAddingTimeInterval:60*60*24*3]];
    [defaultCachedPunchOnLogs addObject:punchOnLogThree];
    
    
    return defaultCachedPunchOnLogs;
}


@end
