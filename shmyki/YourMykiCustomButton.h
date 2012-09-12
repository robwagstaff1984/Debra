//
//  yourMykiBarButtonItem.h
//  shmyki
//
//  Created by Robert Wagstaff on 11/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourMykiCustomButton : UIBarButtonItem

+ (UIBarButtonItem*)createYourMykiBarButtonItemWithText:(NSString*) text withTarget:(id)target withAction:(SEL)action isEnabled:(BOOL)isEnabled;

@end
