//
//  LoginViewController.m
//  Reconnect
//
//  Created by Michael Gao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "LoginViewController.h"
#import "ReconnectAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction definitions

- (IBAction)loginWithFacebook:(id)sender {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] authorize:permissions];
}

@end
