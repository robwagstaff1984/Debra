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
#import "SA_OAuthTwitterEngine.h"  
#import "ShmykiContstants.h"
#import "PunchOnLogsCache.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize navigationController = _navigationController;
@synthesize facebook, twitterEngine, currentUsersPunchOnLog, isTwitterRequired, isFaceBookRequired;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"0ZOhCs6SN4VQ6KfvV1nHUQrXSpU391AiWStEGKpf"
                  clientKey:@"nHODOwsVCOGeziCH3byVfDdQVZECBvWqCZHApSS9"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *mykiBalanceViewController = [[MykiBalanceViewController alloc] initWithNibName:@"MykiBalanceViewController" bundle:nil];
    
    UIViewController *punchOnViewController = [[PunchOnViewController alloc] initWithNibName:@"PunchOnViewController" bundle:nil];
    UINavigationController *punchOnNavController = [[UINavigationController alloc] initWithRootViewController:punchOnViewController];
    
    if ([punchOnNavController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] == YES) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"images/Header.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    punchOnNavController.navigationBar.tintColor= [[UIColor alloc] initWithRed:.35686 green:.5098 blue:.67058 alpha:1];
    
    UIViewController *inspectorMapViewController = [[InspectorMapViewController alloc] initWithNibName:@"InspectorMapViewController" bundle:nil];
    
    UINavigationController *mykiBalanceNavController = [[UINavigationController alloc] initWithRootViewController:mykiBalanceViewController];
    
    mykiBalanceNavController.navigationBar.tintColor= [[UIColor alloc] initWithRed:.35686 green:.5098 blue:.67058 alpha:1];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:punchOnNavController, inspectorMapViewController, mykiBalanceNavController, nil];
    
    
    //self.tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor redColor];
    
    if ([[self.tabBarController tabBar] respondsToSelector:@selector(setBackgroundImage:)] == YES) {
        //[[UITabBar appearance] setTintColor:[[UIColor alloc] initWithRed:.32157 green:.35686 blue:.39216 alpha:1]];
       // [[UITabBar appearance] setSelectedImageTintColor:[[UIColor alloc] initWithRed:.23137 green:.26275 blue:.29804 alpha:1]];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"images/TabBar.png"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"images/TabBarOn.png"]];
    }
   
    
    

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    currentUsersPunchOnLog = [[PunchOnLog alloc] init];
    
    [self setUpFaceBook];
    [self setUpTwitter];
    return YES;
}

#pragma mark Facebook
#pragma mark Facebook

-(void) setUpFaceBook {
    
    facebook = [[Facebook alloc] initWithAppId:@"201775129951445" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKeyNew"] 
        && [defaults objectForKey:@"FBExpirationDateKeyNew"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKeyNew"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKeyNew"];
    }
}

-(void) logInToFacebook {
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions", 
                                nil];
        [facebook authorize:permissions];
        [facebook authorize:nil];
    }
}
-(void) logOutOfFacebook {
    [facebook logout];
}

-(void) postToFacebook {
    if(self.isFaceBookRequired) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        NSString *facebookMessage = [NSString stringWithFormat:@"I just punched on with yourKi:\n\n\"%@\"",  currentUsersPunchOnLog.message];
        [params setObject:facebookMessage forKey:@"message"];
        [params setObject:@"http://www.facebook.com/YourKiApp" forKey:@"link"];
        [params setObject:@"Get the app that give you your Myki balance, ticket inspector locations and access to the YourKi community" forKey:@"caption"];
        [params setObject:@"YourKi -  \"It's YOUR key\""  forKey:@"description"];
        //[params setObject:@"http://a5.sphotos.ak.fbcdn.net/hphotos-ak-snc6/s720x720/251964_337995966278198_401361979_n.jpg"  forKey:@"picture"];
        
        [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    }
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKeyNew"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKeyNew"];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    self.isFaceBookRequired = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookCancelled" object:nil];
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}
- (void)fbDidLogout {
    
}

- (void)fbSessionInvalidated {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

#pragma mark twitter 

-(void) setUpTwitter {
    if(!twitterEngine){  
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        twitterEngine.consumerKey    = kOAuthConsumerKey;  
        twitterEngine.consumerSecret = kOAuthConsumerSecret;  
    } 
}

- (UIViewController*) getlogInToTwitterViewController {
    if(![twitterEngine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];  
        
        if (controller){  
            return controller;
        }  
    } 
    return nil;
}

-(void) postToTwitter {
    
    if(self.isTwitterRequired) { 
        NSString *twitterMessage = [NSString stringWithFormat:@"I just punched on with yourMyki:\n\n\"%@\"\n\n@yourMyki #yourMyki",  currentUsersPunchOnLog.message];
    
        [twitterEngine sendUpdate:twitterMessage];
    }
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    self.isTwitterRequired = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TwitterCancelled" object:nil];
    
}

#pragma mark Facebook request delegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
        NSLog(@"2%@", error);
}
- (void)request:(FBRequest *)request didLoad:(id)result {
       NSLog(@"didLoad"); 
}

#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: data forKey: @"authData"];  
    [defaults synchronize];  
}  

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
}  

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier);  
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
}  

#pragma mark Parse

-(void) saveCurrentUsersPunchOnLog {
    PFObject *punchOnLogParseObject = [PFObject objectWithClassName:@"PunchOnLog"];
    
    NSString *message = currentUsersPunchOnLog.message ? currentUsersPunchOnLog.message : @"" ;
    NSString *location = [self convertLocationToShortLocation:currentUsersPunchOnLog.location];
    NSNumber *transportationType = [NSNumber numberWithInteger:currentUsersPunchOnLog.transportationType]; 
    
    [punchOnLogParseObject setObject:location forKey:@"location"];
    [punchOnLogParseObject setObject:message forKey:@"message"];
    [punchOnLogParseObject setObject:transportationType forKey:@"transportationType"];
    [punchOnLogParseObject saveInBackground];
    
    PunchOnLog *punchOnLog= [[PunchOnLog alloc] init];
    [punchOnLog setMessage:message];
    [punchOnLog setLocation:location];
    [punchOnLog setTransportationType:[transportationType integerValue]];
    [punchOnLog setDateLogged:[[NSDate date] dateByAddingTimeInterval:60*60*24*1]];
    
    NSMutableArray* punchOnLogsCache = [[PunchOnLogsCache sharedModel] loadPunchOnLogsCache];
    [punchOnLogsCache insertObject:punchOnLog atIndex:0];
    [[PunchOnLogsCache sharedModel] savePunchOnLogsCache:punchOnLogsCache];
}

-(NSString*) convertLocationToShortLocation: (NSString*)location {
    NSString* shortLocation = @"";
    if(currentUsersPunchOnLog.location != nil) {
        if(currentUsersPunchOnLog.transportationType == SELECTED_TRANSPORT_TRAIN) {
            shortLocation = currentUsersPunchOnLog.location;
        } else {
            NSRange rangeOfFirstSpaceCharacter = [currentUsersPunchOnLog.location rangeOfString:@" "];
            shortLocation = [currentUsersPunchOnLog.location substringToIndex:rangeOfFirstSpaceCharacter.location];
            shortLocation = [NSString stringWithFormat:@"Route %@", shortLocation];
        }
    }
    return shortLocation;
}

#pragma mark multitask
-(void) reloadMykiBalance {
   
    for (UIViewController *vc in self.tabBarController.viewControllers) {
        if ([vc isKindOfClass:[UINavigationController class]]){
            
            if ([[(UINavigationController*)vc topViewController] isKindOfClass:[MykiBalanceViewController class]]) {
                [(MykiBalanceViewController*)[(UINavigationController*)vc topViewController] retrieveMykiBalance];
            }
        }
    }
}

-(void) stopMykiBalanceLoading {
    for (UIViewController *vc in self.tabBarController.viewControllers) {
        if ([vc isKindOfClass:[UINavigationController class]]){
            
            if ([[(UINavigationController*)vc topViewController] isKindOfClass:[MykiBalanceViewController class]]) {
                [(MykiBalanceViewController*)[(UINavigationController*)vc topViewController] stopRequest];
            }
        }
    }    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    [self stopMykiBalanceLoading];
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
    [self reloadMykiBalance];
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
