//
//  yourMykiBarButtonItem.m
//  shmyki
//
//  Created by Robert Wagstaff on 11/07/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "YourMykiCustomButton.h"

@implementation YourMykiCustomButton

+ (UIBarButtonItem*)createYourMykiBarButtonItemWithText:(NSString*) text withTarget:(id)target withAction:(SEL)action {
    UIButton *yourMykiBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yourMykiBarButton setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    [yourMykiBarButton setTitle:text forState:UIControlStateNormal];
    [yourMykiBarButton setFrame:CGRectMake(0.0f, 0.0f, 70.0f, 44.0f)];
    [yourMykiBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [yourMykiBarButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f]];
    [yourMykiBarButton.titleLabel setTextColor:[UIColor whiteColor]];
    UIBarButtonItem *yourMykiBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:yourMykiBarButton];
    
    [yourMykiBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIColor colorWithRed:220.0/255.0 green:104.0/255.0 blue:1.0/255.0 alpha:1.0], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    return yourMykiBarButtonItem;
}

@end
