//
//  ReconnectTabControllerViewController.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectTabControllerViewController.h"
#import "ReconnectAppDelegate.h"

@interface ReconnectTabControllerViewController ()

@property (nonatomic, strong) FBRequest *meRequest;
@property (nonatomic, strong) FBRequest *myLikesRequest;
@property (nonatomic, strong) FBRequest *friendsLikesRequest;
@property (nonatomic, strong) FBRequest *myFriendsRequest;
@property (nonatomic, strong) NSMutableDictionary *myFriends;

@end

@implementation ReconnectTabControllerViewController

@synthesize meRequest = _meRequest;
@synthesize myLikesRequest = _myLikesRequest;
@synthesize friendsLikesRequest = _friendsLikesRequest;
@synthesize myFriendsRequest = _myFriendsRequest;
@synthesize myFriends = _myFriends;

#pragma mark - Getters & Setters
- (NSMutableDictionary*)myFriends {
    if (!_myFriends) {
        _myFriends = [[NSMutableDictionary alloc] init];
    }
    
    return _myFriends;
}

#pragma mark - FBRequestDelegate Methods
@synthesize greeting;
@synthesize myLike = _myLike;
@synthesize friendLike = _friendLike;

- (void)request:(FBRequest *)request didLoad:(id)result { 
    NSString *requestType = [request.params objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"meRequest"]) {
        NSLog(@"did load me request");
        // update label with current user's name
        self.greeting.text = [NSString stringWithFormat:@"Hello %@", [result objectForKey:@"name"]];
    } else if ([requestType isEqualToString:@"myLikesRequest"]) {
        NSLog(@"did load my likes request");
        self.myLike.text = [NSString stringWithFormat:@"You like %@", [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"name"]];
        //        NSLog(@"%@", result);
    } else if ([requestType isEqualToString:@"myFriendsRequest"]) {
        // loop through all results and store in myFriends dictionary
        NSArray *data = [result objectForKey:@"data"];
        
        NSMutableString *friendsIDs = [[NSMutableString alloc] init];
        int friendCounter = 0;
        // loop through friends and concat IDs to params
        for (NSDictionary *friend in data) {
            friendCounter++;
            [self.myFriends setObject:[friend objectForKey:@"name"] forKey:[friend objectForKey:@"id"]];
            
            if (friendCounter == 100) {
                NSLog(@"retrieving 100 friends' likes");
                [friendsIDs appendFormat:@"%@", [friend objectForKey:@"id"]];
                NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];
                //                NSLog(@"%@", friendsIDs);
                self.friendsLikesRequest = [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
                friendCounter = 0;
                [friendsIDs setString:@""];
            } else {
                [friendsIDs appendFormat:@"%@,", [friend objectForKey:@"id"]];
            }
        }
        
        // take care of last group of friends
        if ([friendsIDs length] > 0) {
            // if last character is a comma, remove it
            if ([[friendsIDs substringFromIndex:[friendsIDs length] - 1] isEqualToString:@","]) {
                [friendsIDs setString:[friendsIDs substringToIndex:[friendsIDs length] -1]];
            }
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];
        //  NSLog(@"%@", friendsIDs);
        self.friendsLikesRequest = [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
        
        //        NSLog(@"friends: %@", self.myFriends);
    } else if ([requestType isEqualToString:@"myFriendsLikesRequest"]) {
        NSLog(@"did load friends likes request");
        //        self.friendLike.text = [NSString stringWithFormat:@"Your friend Kimberly likes %@", [[[[[result objectForKey:@"kimhsiao"] objectForKey:@"likes"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"name"]];
        NSLog(@"%@", result);
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"request: %@", request.params);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FBRequestDelegate Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}


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
    
    NSLog(@"logged out");
}

- (void)fbSessionInvalidated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"reconnect view controller did appear");
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    [facebook requestWithGraphPath:@"me" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"meRequest", @"requestType", nil] andDelegate:self];
    [facebook requestWithGraphPath:@"me/friends" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myFriendsRequest", @"requestType", nil] andDelegate:self];
    [facebook requestWithGraphPath:@"me/likes" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myLikesRequest", @"requestType", nil] andDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setGreeting:nil];
    [self setMyLike:nil];
    [self setFriendLike:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)logoutOfFacebook:(id)sender {
    [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] logout];
}


@end
