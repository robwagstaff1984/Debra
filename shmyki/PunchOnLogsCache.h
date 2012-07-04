//
//  PunchOnLogsCache.h
//  shmyki
//
//  Created by Robert Wagstaff on 4/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PunchOnLogsCache : NSObject

+ (id)sharedModel;
-(void)savePunchOnLogsCache:(NSMutableArray*)cachedPunchOnLogs;
-(NSMutableArray*) loadPunchOnLogsCache;
    
@end
