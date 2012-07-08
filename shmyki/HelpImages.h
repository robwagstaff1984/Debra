//
//  HelpImages.h
//  shmyki
//
//  Created by Robert Wagstaff on 8/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpImages : NSObject

@property (nonatomic) BOOL isPunchOnHelpAlreadySeen;
@property (nonatomic) BOOL isInspectorHelpAlreadySeen;

-(void) saveHelpImageRequiredInfo;
-(void) loadHelpImageRequiredInfo;

@end
