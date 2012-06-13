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
#import "RFacebookLike.h"
#import "RFriend.h"
#import "ReconnectAppDelegate.h"

@interface CompatibilityTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *myFriends;
//@property (nonatomic, strong) NSMutableDictionary *myLikes;
@property (nonatomic, strong) NSMutableSet *myLikes;        // set of ids (of facebook pages)
@property (nonatomic, strong) NSMutableArray *myFriendsAndScores;
@property NSUInteger myLikesCount;

@end

@implementation CompatibilityTableViewController

@synthesize myFriends = _myFriends;
@synthesize myLikes = _myLikes;
@synthesize myFriendsAndScores = _myFriendsAndScores;
@synthesize myLikesCount = _myLikesCount;

#pragma mark - Getters & Setters
- (NSMutableDictionary*)myFriends {
    if (!_myFriends) {
        _myFriends = [[NSMutableDictionary alloc] init];
    }
    
    return _myFriends;
}

- (NSMutableSet*)myLikes {
    if (!_myLikes) {
//        _myLikes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                        [[NSMutableSet alloc] init], @"Music",              // Musician/band
//                        [[NSMutableSet alloc] init], @"MoviesAndTv",        // Movie, Tv show, Tv channel, Tv network
//                        [[NSMutableSet alloc] init], @"Books",              // Book
//                        nil];
        _myLikes = [[NSMutableSet alloc] init];
    }
    
    return _myLikes;
}

- (NSMutableArray*)myFriendsAndScores {
    if (!_myFriendsAndScores) {
        _myFriendsAndScores = [[NSMutableArray alloc] init];
    }
    
    return _myFriendsAndScores;
}

#pragma mark - FBRequestDelegate Methods

- (void)request:(FBRequest *)request didLoad:(id)result { 
    NSString *requestType = [request.params objectForKey:@"requestType"];
    if ([requestType isEqualToString:@"meRequest"]) {
        NSLog(@"did load me request");
        
    } else if ([requestType isEqualToString:@"myLikesRequest"]) {
        NSLog(@"did load my likes request");
        NSArray *data = [result objectForKey:@"data"];
        for (NSDictionary *myLike in data) {
            NSString *currentCategory = [myLike objectForKey:@"category"];
            if ([currentCategory isEqualToString:@"Musician/band"]) {
                RFacebookLike *like = [[RFacebookLike alloc] init];
                like.id = [myLike objectForKey:@"id"];
                like.name = [myLike objectForKey:@"name"];
                [[self.myLikes objectForKey:@"Music"] addObject:like];
                self.myLikesCount++;
            } else if ([currentCategory isEqualToString:@"Movie"] || [currentCategory isEqualToString:@"Tv show"] || 
                       [currentCategory isEqualToString:@"Tv channel"] || [currentCategory isEqualToString:@"Tv network"]) {
                RFacebookLike *like = [[RFacebookLike alloc] init];
                like.id = [myLike objectForKey:@"id"];
                like.name = [myLike objectForKey:@"name"];
                [[self.myLikes objectForKey:@"MoviesAndTv"] addObject:like];
                self.myLikesCount++;
            } else if ([currentCategory isEqualToString:@"Book"]) {
                RFacebookLike *like = [[RFacebookLike alloc] init];
                like.id = [myLike objectForKey:@"id"];
                like.name = [myLike objectForKey:@"name"];
                [[self.myLikes objectForKey:@"Books"] addObject:like];
                self.myLikesCount++;
            }
        }
        
//        NSLog(@"%@", self.myLikes);
        
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

                [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
//                friendCounter = 0;
//                [friendsIDs setString:@""];
            } else {
                [friendsIDs appendFormat:@"%@,", [friend objectForKey:@"id"]];
            }
        }
        
        // take care of last group of friends
//        if ([friendsIDs length] > 0) {
//            // if last character is a comma, remove it
//            if ([[friendsIDs substringFromIndex:[friendsIDs length] - 1] isEqualToString:@","]) {
//                [friendsIDs setString:[friendsIDs substringToIndex:[friendsIDs length] -1]];
//            }
//        }
//        
//        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];
//        [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
        
        //        NSLog(@"friends: %@", self.myFriends);
    } else if ([requestType isEqualToString:@"myFriendsLikesRequest"]) {
        NSLog(@"did load friends likes request");
        NSSet *myMusicLikes = [self.myLikes objectForKey:@"Music"];
        NSSet *myMoviesAndTvLikes = [self.myLikes objectForKey:@"MoviesAndTv"];
        NSSet *myBooksLikes = [self.myLikes objectForKey:@"Books"];
        
        for (NSString* friendID in [result allKeys]) {
            RFriend *currentFriend = [[RFriend alloc] init];
            currentFriend.name = [result objectForKey:friendID];
            currentFriend.compatScore = 0.0f;
            currentFriend.totalLikes = 0;
            currentFriend.sameLikes = 0;
            
            NSArray *friendLikes = [[[result objectForKey:friendID] objectForKey:@"likes"] objectForKey:@"data"];
            for (NSDictionary *friendLike in friendLikes) {
                NSString *currentCategory = [friendLike objectForKey:@"category"];
                
                if ([currentCategory isEqualToString:@"Musician/band"]) {
                    
                } else if ([currentCategory isEqualToString:@"Movie"] || [currentCategory isEqualToString:@"Tv show"] || 
                           [currentCategory isEqualToString:@"Tv channel"] || [currentCategory isEqualToString:@"Tv network"]) {
                    
                } else if ([currentCategory isEqualToString:@"Book"]) {
                    
                }
            }
        }
//        NSLog(@"%@", result);
    }
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
    
    NSLog(@"reconnect view controller did appear");
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    [facebook requestWithGraphPath:@"me" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"meRequest", @"requestType", nil] andDelegate:self];
    [facebook requestWithGraphPath:@"me/friends" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myFriendsRequest", @"requestType", nil] andDelegate:self];
    [facebook requestWithGraphPath:@"me/likes" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myLikesRequest", @"requestType", nil] andDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myLikesCount = 0;
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
