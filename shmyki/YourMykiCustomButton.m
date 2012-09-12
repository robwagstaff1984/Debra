//
//  yourMykiBarButtonItem.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "YourMykiCustomButton.h"

@implementation YourMykiCustomButton

+ (UIBarButtonItem*)createYourMykiBarButtonItemWithText:(NSString*) text withTarget:(id)target withAction:(SEL)action isEnabled:(BOOL)isEnabled {
    UIButton *yourMykiBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yourMykiBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    [yourMykiBarButton setTitle:text forState:UIControlStateNormal];
    [yourMykiBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
    [yourMykiBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [yourMykiBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    if(isEnabled) {
        [yourMykiBarButton.titleLabel setTextColor:[UIColor whiteColor]];
    } else {
        [yourMykiBarButton.titleLabel setTextColor:[UIColor lightGrayColor]];        
    }
    UIBarButtonItem *yourMykiBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:yourMykiBarButton];
    return yourMykiBarButtonItem;
}

@end
