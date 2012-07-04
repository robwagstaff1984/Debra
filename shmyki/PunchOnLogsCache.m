//
//  PunchOnLogsCache.m
//  shmyki
//
//  Created by Robert Wagstaff on 4/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnLogsCache.h"

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
    NSMutableArray *cachedPunchOnLogs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return cachedPunchOnLogs;
}
@end
