//
//  HelpImages.m
//  shmyki
//
//  Created by Robert Wagstaff on 8/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "HelpImages.h"

@implementation HelpImages

@synthesize isPunchOnHelpAlreadySeen = _isPunchOnHelpAlreadySeen, isInspectorHelpAlreadySeen= _isInspectorHelpAlreadySeen;

-(void) saveHelpImageRequiredInfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setBool:self.isPunchOnHelpAlreadySeen forKey:@"isPunchOnHelpAlreadySeen"];
    [defaults setBool:self.isInspectorHelpAlreadySeen forKey:@"isInspectorHelpAlreadySeen"];
    
    [defaults synchronize];
}
-(void) loadHelpImageRequiredInfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isPunchOnHelpAlreadySeen = [defaults boolForKey:@"isPunchOnHelpAlreadySeen"];
    self.isInspectorHelpAlreadySeen = [defaults boolForKey:@"isInspectorHelpAlreadySeen"];
}

@end
