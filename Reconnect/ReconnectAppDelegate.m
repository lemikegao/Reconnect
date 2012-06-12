//
//  ReconnectAppDelegate.m
//  Reconnect
//
//  Created by Michael Gao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectAppDelegate.h"
#import "ReconnectViewController.h"
#import "LoginViewController.h"

@implementation ReconnectAppDelegate

NSString* const FB_APP_ID = @"159351717531143";

@synthesize window = _window;
@synthesize facebook = _facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ReconnectViewController *rootViewController = (ReconnectViewController *)self.window.rootViewController;
    self.facebook = [[Facebook alloc] initWithAppId:FB_APP_ID andDelegate:rootViewController];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![self.facebook isSessionValid]) {
//        [self.facebook authorize:nil];
        UIStoryboard *iphoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *loginViewController = [iphoneStoryboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [self.window makeKeyAndVisible];    // making window visible so loginViewController is pushed modally
        [rootViewController presentViewController:loginViewController animated:NO completion:nil];
    }
    
    return YES;
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]; 
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.facebook extendAccessTokenIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
