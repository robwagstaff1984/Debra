//
//  DateDisplayHelper.h
//  shmyki
//
//  Created by Robert Wagstaff on 10/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    YourMykiInspectorPage = 0,
    YourMykiPunchOnPage = 1,
    YourMykiIBalancePage = 2,
} YourMykiPage;


@interface DateDisplayHelper : NSObject

@property NSDateFormatter *dateFormatter;
-(NSString*) getDisplayForDate:(NSDate*)date forPage:(YourMykiPage) yourMykiPage;

@end
