//
//  StatusUpdateViewController.m
//  Reconnect
//
//  Created by Michael Gao on 6/13/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "StatusUpdateViewController.h"
#import "ReconnectAppDelegate.h"

@interface StatusUpdateViewController ()

@end

@implementation StatusUpdateViewController

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

- (IBAction)logout:(id)sender {
    [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] logout];
}
@end
