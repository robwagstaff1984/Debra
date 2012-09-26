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
        [issues addObject:@"Select a problem"];
        [issues addObject:@"I just want to rant"];
        [issues addObject:@"The tap machine didn't work"];
        [issues addObject:@"My myki card won't work"];
        [issues addObject:@"Unable to top up at Myki machine"];
        [issues addObject:@"Myki overcharged me"];
        [issues addObject:@"It takes too long to top up online"];
        [issues addObject:@"Bad customer service"];
        [issues addObject:@"The metcard system was better"];
        [issues addObject:@"Myki tracks my location without my consent"];
        [issues addObject:@"Other"];
    }
    return self;
}

@end
