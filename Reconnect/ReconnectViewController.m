//
//  ReconnectViewController.m
//  Reconnect
//
//  Created by Michael Gao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectViewController.h"
#import "ReconnectAppDelegate.h"

@interface ReconnectViewController ()

@end

@implementation ReconnectViewController

#pragma mark -- FBSessionDelegate methods
- (void)fbDidLogin {
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:NO completion:nil]; // dismisses loginViewController
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
    
}

- (void)fbSessionInvalidated {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
