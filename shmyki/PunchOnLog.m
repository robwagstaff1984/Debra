//
//  PunchOnLog.m
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnLog.h"

@implementation PunchOnLog

@synthesize message, location, transportationType, dateLogged;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeInteger:transportationType forKey:@"transportationType"];
    [encoder encodeObject:dateLogged forKey:@"dateLogged"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.message = [decoder decodeObjectForKey:@"message"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.transportationType = [decoder decodeIntegerForKey:@"transportationType"];
    self.dateLogged = [decoder decodeObjectForKey:@"dateLogged"];
    return self;
}

@end
