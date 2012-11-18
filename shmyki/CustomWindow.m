////
////  CustomWindow.m
////  shmyki
////
////  Created by Robert Wagstaff on 1/11/12.
////  Copyright (c) 2012 DWS Limited. All rights reserved.
////
//
//#import "CustomWindow.h"
//#import "AppDelegate.h"
//#import "PunchOnViewController.h"
//#import <UIKit/UIKit.h>
//
//@implementation CustomWindow
//@synthesize interceptEvents;
//- (void) sendEvent:(UIEvent *)event
//{
//
//    if(interceptEvents) {
//    BOOL flag = YES;
//    switch ([event type])
//    {
//            //trying to pass on the event to punch on VC
//        case UIEventTypeTouches:
//            UITabBarController *tabBar = [[UITabBarController alloc] init];
//        tabBar = [(AppDelegate*)[[UIApplication sharedApplication]delegate] tabBarController];
//        
//        for (UIViewController *vc in tabBar) {
//            if ([vc isKindOfClass:[UINavigationController class]]){
//                
//                if ([[(UINavigationController*)vc topViewController] isKindOfClass:[PunchOnViewController class]]) {
//                    [(PunchOnViewController*)[(UINavigationController*)vc topViewController] toggleCommentsTableViewUpAndDown];
//                    // [(PunchOnViewController*)[(UINavigationController*)vc topViewController] retrieveMykiBalance];
//                }
//            }
//        }
//            //[self catchUIEventTypeTouches: event]; perform if you need to do something with event
//            /*for (UITouch *touch in [event allTouches]) {
//                if ([touch phase] == UITouchPhaseBegan) {
//                    for (int i=0; i<[self.subviews count]; i++) {
//                        //GET THE FINGER LOCATION ON THE SCREEN
//                        CGPoint location = [touch locationInView:[self.subviews objectAtIndex:i]];
//                        
//                        //REPORT THE TOUCH
//                        NSLog(@"[%@] touchesBegan (%i,%i)",  [[self.subviews objectAtIndex:i] class],(NSInteger) location.x, (NSInteger) location.y);
//                        if (((NSInteger)location.y) == 64) {
//                            flag = NO;
//                        }
//                    }
//                }
//            }*/
//            
//            break;
//            
//        default:
//            break;
//    }
//        if(!flag) return; //to do nothing
//    }
//    
//    /*IMPORTANT[super sendEvent:(UIEvent *)event];IMPORTANT*/
//}
//
//@end
