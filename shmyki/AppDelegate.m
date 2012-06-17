//
//  AppDelegate.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "AppDelegate.h"

#import "PunchOnViewController.h"
#import "InspectorMapViewController.h"
#import "InformationViewController.h"
#import "PunchOnLogsViewController.h"
#import "MykiBalanceViewController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"%@",@"time start");
    UIViewController *mykiBalanceViewController = [[MykiBalanceViewController alloc] initWithNibName:@"MykiBalanceViewController" bundle:nil];
    
    UIViewController *punchOnViewController = [[PunchOnViewController alloc] initWithNibName:@"PunchOnViewController" bundle:nil];
    UINavigationController *punchOnNavController = [[UINavigationController alloc] initWithRootViewController:punchOnViewController];
    
    UIViewController *inspectorMapViewController = [[InspectorMapViewController alloc] initWithNibName:@"InspectorMapViewController" bundle:nil];
    
    UIViewController *informationViewController = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    


    UINavigationController *mykiBalanceNavController = [[UINavigationController alloc] initWithRootViewController:mykiBalanceViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:punchOnNavController, inspectorMapViewController,  informationViewController, mykiBalanceNavController, nil];
    
    

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [Parse setApplicationId:@"0ZOhCs6SN4VQ6KfvV1nHUQrXSpU391AiWStEGKpf"
                  clientKey:@"nHODOwsVCOGeziCH3byVfDdQVZECBvWqCZHApSS9"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
