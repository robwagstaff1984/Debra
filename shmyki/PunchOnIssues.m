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
        [issues addObject:@"Placeholder issue 1"];
        [issues addObject:@"Placeholder issue 2"];
        [issues addObject:@"Placeholder issue 3"];
        [issues addObject:@"Placeholder issue 4"];
        [issues addObject:@"Other"];
    }
    return self;
}

@end
