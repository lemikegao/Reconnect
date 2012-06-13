//
//  CompatibilityTableViewController.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "CompatibilityTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "CompatibilityCell.h"
#import "ReconnectAppDelegate.h"

@interface CompatibilityTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *myFriends;

@end

@implementation CompatibilityTableViewController

@synthesize myFriends = _myFriends;

#pragma mark - Getters & Setters
- (NSMutableDictionary*)myFriends {
    if (!_myFriends) {
        _myFriends = [[NSMutableDictionary alloc] init];
    }
    
    return _myFriends;
}

#pragma mark - FBRequestDelegate Methods

- (void)request:(FBRequest *)request didLoad:(id)result { 
    NSString *requestType = [request.params objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"meRequest"]) {
        NSLog(@"did load me request: %@",result);
        // update label with current user's name
    } else if ([requestType isEqualToString:@"myLikesRequest"]) {
        NSLog(@"did load my likes request: %@", result);
        
#warning - 
//    } else if ([requestType isEqualToString:@"myFriendsLikesRequest"]) {
    } else {
        NSLog(@"got my friends likes response: %@",result);
//        // loop through all results and store in myFriends dictionary
//        NSArray *data = [result objectForKey:@"data"];
//        
//        NSMutableString *friendsIDs = [[NSMutableString alloc] init];
//        int friendCounter = 0;
//        // loop through friends and concat IDs to params
//        for (NSDictionary *friend in data) {
//            friendCounter++;
//            [self.myFriends setObject:[friend objectForKey:@"name"] forKey:[friend objectForKey:@"id"]];
//            
//            if (friendCounter == 100) {
//                NSLog(@"retrieving 100 friends' likes");
//                [friendsIDs appendFormat:@"%@", [friend objectForKey:@"id"]];
//                NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];
//
//                [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
//                friendCounter = 0;
//                [friendsIDs setString:@""];
//            } else {
//                [friendsIDs appendFormat:@"%@,", [friend objectForKey:@"id"]];
//            }
//        }
//        
//        // take care of last group of friends
//        if ([friendsIDs length] > 0) {
//            // if last character is a comma, remove it
//            if ([[friendsIDs substringFromIndex:[friendsIDs length] - 1] isEqualToString:@","]) {
//                [friendsIDs setString:[friendsIDs substringToIndex:[friendsIDs length] -1]];
//            }
//        }
        
//        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];
//        //  NSLog(@"%@", friendsIDs);
//        [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
    } 
//    else if ([requestType isEqualToString:@"myFriendsLikesRequest"]) {
//        NSLog(@"did load friends likes request");
//    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"request: %@", request.params);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FBRequestDelegate Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    // get me
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    [facebook requestWithGraphPath:@"me" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"meRequest", @"requestType", nil] andDelegate:self];
    
    // get my likes
    NSString *myLikes = @"SELECT page_id, name, type FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE type in ('MUSICIAN/BAND','MOVIE','TV SHOW','TV CHANNEL','TV NETWORK','BOOK') and uid =me())";
    NSMutableDictionary *myLikesParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:myLikes,@"query",@"myLikesRequest",@"requestType",nil];
    [facebook requestWithMethodName:@"fql.query" andParams:myLikesParams andHttpMethod:@"POST" andDelegate:self];
    
    // get pageIDs of my friends likes
    NSString *myFriends = @"SELECT uid2 from friend where uid1 = me()";
    NSString *myFriendsPages = @"SELECT uid, page_id, type FROM page_fan WHERE type in ('MUSICIAN/BAND','MOVIE','TV SHOW','TV CHANNEL','TV NETWORK','BOOK') and uid in (select uid2 from #myFriendsQuery)";
    NSString *fqlStatement = [NSString stringWithFormat:@"{\"myFriendsQuery\":\"%@\",\"myFriendsPagesQuery\":\"%@\"}",myFriends,myFriendsPages];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fqlStatement forKey:@"queries"];
    [facebook requestWithMethodName:@"fql.multiquery" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
    // get names of common likes -- get first 3
    NSString *commonLikesNames = @"SELECT name FROM page where page_id in ('10705539669','93944052260','6483988719','10510685798')";
    NSMutableDictionary *commonLikesNamesParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:commonLikesNames, @"query",@"commonLikesNamesRequest",@"requestType", nil];
    [facebook requestWithMethodName:@"fql.query" andParams:commonLikesNamesParams andHttpMethod:@"POST" andDelegate:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompatibilityCell";
    CompatibilityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString* profilePicURL = @"http://graph.facebook.com/kimhsiao/picture";
    UIImage *profilePic = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicURL]]];

    cell.imageView.image = profilePic;
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.nameLabel.text = @"Kimberly Hsiao";
    cell.similaritiesLabel.text = @"hiasdfasdfasdfaf, MOULIN ROUGE, GOOD WILL HUNTING, ZOOLANDER, HIMYM, FRIENDS";
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath 
{
    return COMPATIBILITYROWHEIGHT;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed: 0.96f green: 0.96f blue: 0.96f alpha: 1.0f];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
