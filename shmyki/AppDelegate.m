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
#import "Facebook.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize navigationController = _navigationController;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"0ZOhCs6SN4VQ6KfvV1nHUQrXSpU391AiWStEGKpf"
                  clientKey:@"nHODOwsVCOGeziCH3byVfDdQVZECBvWqCZHApSS9"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *mykiBalanceViewController = [[MykiBalanceViewController alloc] initWithNibName:@"MykiBalanceViewController" bundle:nil];
    
    UIViewController *punchOnViewController = [[PunchOnViewController alloc] initWithNibName:@"PunchOnViewController" bundle:nil];
    UINavigationController *punchOnNavController = [[UINavigationController alloc] initWithRootViewController:punchOnViewController];
    
    UIViewController *inspectorMapViewController = [[InspectorMapViewController alloc] initWithNibName:@"InspectorMapViewController" bundle:nil];
    
    /*UIViewController *informationViewController = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];*/
    


    UINavigationController *mykiBalanceNavController = [[UINavigationController alloc] initWithRootViewController:mykiBalanceViewController];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:punchOnNavController, inspectorMapViewController, mykiBalanceNavController, nil];
    
    

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
       
    [self setUpFaceBook];
    
    return YES;
}

#pragma mark Facebook

/*-(void) setUpFaceBook {
NSString *client_id = @"332640806811699";

//alloc and initalize our FbGraph instance
facebook = [[FbGraph alloc] initWithFbClientID:client_id];

//begin the authentication process.....
[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
                     andExtendedPermissions:@"publish_stream" andSuperView:self.view];
}

-(void)fbGraphCallback:(id)sender {
    
    if ((fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0)) {
        
        NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
        
    } else {
        NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
        
        NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [variables setObject:@"http://farm6.static.flickr.com/5015/5570946750_a486e741.jpg" forKey:@"link"];
        [variables setObject:@"http://farm6.static.flickr.com/5015/5570946750_a486e741.jpg" forKey:@"picture"];
        [variables setObject:@"You scored 99999" forKey:@"name"];
        [variables setObject:@" " forKey:@"caption"];
        [variables setObject:@"Download my app for the iPhone NOW." forKey:@"description"];
        
        FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"me/feed" withPostVars:variables];
        NSLog(@"postMeFeedButtonPressed:  %@", fb_graph_response.htmlResponse);
        
        //parse our json
        SBJSON *parser = [[SBJSON alloc] init];
        NSDictionary *facebook_response = [parser objectWithString:fb_graph_response.htmlResponse error:nil];   
        [parser release];
        
        NSLog(@"Now log into Facebook and look at your profile...");
    }
    
    [fbGraph release];
}*/


-(void) setUpFaceBook {
    
    facebook = [[Facebook alloc] initWithAppId:@"332640806811699" andDelegate:self];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    [facebook logout];
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions", 
                                nil];
        [facebook authorize:permissions];
        
        [facebook authorize:nil];
    }
    [self postToFacebook];
}

-(void) postToFacebook {
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    NSString *punchOnMessage = @"The other day myki blah blah blah";
    NSString *facebookMessage = [NSString stringWithFormat:@"I just punched on with yourKi:\n\n\"%@\"",  punchOnMessage];
    [params setObject:facebookMessage forKey:@"message"];
    [params setObject:@"http://www.facebook.com/YourKiApp" forKey:@"link"];
    [params setObject:@"Get the app that give you your Myki balance, ticket inspector locations and access to the YourKi community" forKey:@"caption"];
    [params setObject:@"YourKi -  \"It's YOUR key\""  forKey:@"description"];
    [params setObject:@"http://a5.sphotos.ak.fbcdn.net/hphotos-ak-snc6/s720x720/251964_337995966278198_401361979_n.jpg"  forKey:@"picture"];
    
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}


- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"test");
}


- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data {
    NSLog(@"test this %@", data);
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
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
