//
//  ReconnectTabControllerViewController.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectTabBarController.h"
#import "ReconnectAppDelegate.h"
#import "LoginViewController.h"

@interface ReconnectTabBarController ()

@end

@implementation ReconnectTabBarController

#pragma mark -- FBSessionDelegate methods
- (void)fbDidLogin {
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:NO completion:nil]; // dismisses loginViewController
    NSLog(@"logged in");
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout {
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:loginViewController animated:NO completion:nil];
    
    // release existing view controllers and create new instances for next user who logs in
    UIViewController* compatibilityNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"compatibilityNavigationController"];
    UIViewController* statusUpdateNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"statusUpdateNavigationController"];
    UIViewController* topPicksNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"topPicksNavigationController"];
    NSArray* newTabViewControllers = [NSArray arrayWithObjects:compatibilityNavigationController, statusUpdateNavigationController, topPicksNavigationController, nil];
    self.viewControllers = newTabViewControllers;
    self.selectedIndex = 0;
    
    NSLog(@"logged out");
}

- (void)fbSessionInvalidated {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
