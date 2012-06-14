//
//  PunchOnIssues.m
//  shmyki
//
//  Created by Robert Wagstaff on 14/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnIssues.h"

@implementation PunchOnIssues

@synthesize issues;

-(id)init {
    
    self = [super init];
    
    if (self != nil) {
        issues = [[NSMutableArray alloc] init];
        [issues addObject:@"Generally unhappy with Myki"];
        [issues addObject:@"Generally happy with Myki"];
        [issues addObject:@"Myki machine was broken"];
        [issues addObject:@"Unable to top up at Myki machine"];
        [issues addObject:@"Myki overcharged me"];
    }
    return self;
}

@end
