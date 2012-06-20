//
//  PunchOnLog.h
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PunchOnLog : NSObject

@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSDate *dateLogged;

@end