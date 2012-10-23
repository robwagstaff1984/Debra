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
        [issues addObject:@"Tap on reader didn't work"];
        [issues addObject:@"Tap on reader is slow, causing people jams"];
        [issues addObject:@"'Multiple card read' error is frustrating"];
        [issues addObject:@"Myki tracks my location without my consent"];
        [issues addObject:@"Top up machine is not working"];
        [issues addObject:@"Top up machines are hard to use"];
        [issues addObject:@"Myki overcharged me"];
        [issues addObject:@"I never know how or when I'm charged"];
        [issues addObject:@"I'm confused about how fares are calculated"];
        [issues addObject:@"I never know when to tap on and off"];
        [issues addObject:@"My myki card won't work"];
        [issues addObject:@"I hate having to buy a Myki card"];
        [issues addObject:@"Online top up takes 24 hours to take effect"];
        [issues addObject:@"Myki website is hard to use"];
        [issues addObject:@"I can't suspend my pass if I'm away"];
        [issues addObject:@"Myki pass won't work without myki money"];
        [issues addObject:@"Bad customer service"];
        [issues addObject:@"The metcard system was better"];
        [issues addObject:@"Other"];        
    }
    return self;
}

@end
