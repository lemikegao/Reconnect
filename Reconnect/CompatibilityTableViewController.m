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
@property (nonatomic, strong) NSArray *mySortedFriendsAndScores;
@property (nonatomic, strong) NSMutableDictionary *pageIdToName;
@property BOOL doneProcessing;

@end

@implementation CompatibilityTableViewController

@synthesize myFriends = _myFriends;
@synthesize myLikes = _myLikes;
@synthesize myFriendsAndScores = _myFriendsAndScores;
@synthesize mySortedFriendsAndScores = _mySortedFriendsAndScores;
@synthesize pageIdToName = _pageIdToName;
@synthesize doneProcessing = _doneProcessing;

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

- (NSArray*)mySortedFriendsAndScores {
    if (!_mySortedFriendsAndScores) {
        _mySortedFriendsAndScores = [[NSArray alloc] init];
    }
    
    return _mySortedFriendsAndScores;
}

- (NSMutableDictionary*)pageIdToName {
    if (!_pageIdToName) {
        _pageIdToName = [[NSMutableDictionary alloc] init];
    }
    
    return _pageIdToName;
}

#pragma mark - FBRequestDelegate Methods

- (void)request:(FBRequest *)request didLoad:(id)result { 
    NSString *requestType = [request.params objectForKey:@"requestType"];
    
    if ([requestType isEqualToString:@"meRequest"]) {
        NSLog(@"did load me request");
        
    } else if ([requestType isEqualToString:@"myLikesRequest"]) {
        NSLog(@"did load my likes request");
        NSArray *data = [result objectForKey:@"data"];
        /* FQL
        for (NSDictionary *pageID in data) {
            [self.myLikes addObject:[pageID objectForKey:@"page_id"]];
        }
         */
        for (NSDictionary *myLike in data) {
            NSString *currentCategory = [myLike objectForKey:@"category"];

            if ([currentCategory isEqualToString:@"Musician/band"] || [currentCategory isEqualToString:@"Movie"] || [currentCategory isEqualToString:@"Tv show"] || [currentCategory isEqualToString:@"Tv channel"] || [currentCategory isEqualToString:@"Tv network"] || [currentCategory isEqualToString:@"Book"]) {
                [self.pageIdToName setObject:[myLike objectForKey:@"name"] forKey:[myLike objectForKey:@"id"]];
                [self.myLikes addObject:[myLike objectForKey:@"id"]];
            }
        }
    } else if ([requestType isEqualToString:@"myFriendsRequest"]) {
        // loop through all results and store in myFriends dictionary
        NSArray *data = [result objectForKey:@"data"];
        
        NSMutableString *friendsIDs = [[NSMutableString alloc] init];
        int friendCounter = 0;
        // loop through friends and concat IDs to params
        for (NSDictionary *friend in data) {
            friendCounter++;
            [self.myFriends setObject:[friend objectForKey:@"name"] forKey:[friend objectForKey:@"id"]];
            
            if (friendCounter == 500) {
                NSLog(@"retrieving 500 friends' likes");
                [friendsIDs appendFormat:@"%@", [friend objectForKey:@"id"]];
                NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:friendsIDs, @"ids", @"myFriendsLikesRequest", @"requestType", nil];

                [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
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
//        //  NSLog(@"%@", friendsIDs);
        [[(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook] requestWithGraphPath:@"likes" andParams:params andDelegate:self];
        
        //        NSLog(@"friends: %@", self.myFriends);
    } else if ([requestType isEqualToString:@"myFriendsLikesRequest"]) {
        NSLog(@"did load friends likes request");
        
        /*
        NSLog(@"%@", [[result objectAtIndex:1] objectForKey:@"fql_result_set"]);
        NSArray *friendsLikes = [[result objectAtIndex:1] objectForKey:@"fql_result_set"];
        NSMutableString *currentID = [[NSMutableString alloc] initWithString:@""];
        NSMutableString *previousID = [[NSMutableString alloc] initWithString:@""];
        RFriend *currentFriend;
        for (NSDictionary *friendLike in friendsLikes) {
            [currentID setString:[[friendLike objectForKey:@"uid"] stringValue]];
            if (![currentID isEqualToString:previousID]) {
                if (currentFriend) {
                    [self.myFriendsAndScores addObject:currentFriend];
                    currentFriend.compatScore = (currentFriend.sameLikes*2) / (float)(currentFriend.totalLikes + [self.myLikes count]);
//                    NSLog(@"%@: %i, %i, %f", currentFriend.name, currentFriend.sameLikes, currentFriend.totalLikes, currentFriend.compatScore);
                }
                currentFriend = [[RFriend alloc] init];
                currentFriend.name = [self.myFriends objectForKey:currentID];
                currentFriend.compatScore = 0.0f;
                currentFriend.totalLikes = 0;
                currentFriend.sameLikes = 0;
            }
            
            currentFriend.totalLikes++;
            if ([self.myLikes containsObject:[friendLike objectForKey:@"page_id"]]) {
                // same like!
                currentFriend.sameLikes++;
            }
            
            [previousID setString:currentID];
        }
         
         */
        
        for (NSString* friendID in [result allKeys]) {
            RFriend *currentFriend = [[RFriend alloc] init];
            currentFriend.friendID = friendID;
            currentFriend.name = [self.myFriends objectForKey:friendID];
            currentFriend.compatScore = 0.0f;
            currentFriend.totalLikes = 0;
            currentFriend.sameLikes = 0;
            
            NSArray *friendLikes = [[result objectForKey:friendID] objectForKey:@"data"];
            for (NSDictionary *friendLike in friendLikes) {
                NSString *currentCategory = [friendLike objectForKey:@"category"];
                if ([currentCategory isEqualToString:@"Musician/band"] || [currentCategory isEqualToString:@"Movie"] || [currentCategory isEqualToString:@"Tv show"] || [currentCategory isEqualToString:@"Tv channel"] || [currentCategory isEqualToString:@"Tv network"] || [currentCategory isEqualToString:@"Book"]) {
                    currentFriend.totalLikes++;
                    if ([self.myLikes containsObject:[friendLike objectForKey:@"id"]]) {
                        // same like!
                        currentFriend.sameLikes++;
                        [currentFriend.commonLikes addObject:[friendLike objectForKey:@"id"]];
                    }
                }
            }
            
            currentFriend.compatScore = (currentFriend.sameLikes*2) / (float)(currentFriend.totalLikes + [self.myLikes count]);
            [self.myFriendsAndScores addObject:currentFriend];
//            NSLog(@"%@: %i, %i, %f", currentFriend.name, currentFriend.sameLikes, currentFriend.totalLikes, currentFriend.compatScore);
        }
        
        NSArray *sortedArray = [self.myFriendsAndScores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            float first = [(RFriend*)a compatScore];
            float second = [(RFriend*)b compatScore];
            
            return (first < second);
        }];
        
        self.mySortedFriendsAndScores = sortedArray;
        self.doneProcessing = YES;
        [self.tableView reloadData];
        NSLog(@"%@", sortedArray);
        NSLog(@"%@", result);
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
        
    // get me
    Facebook *facebook = [(ReconnectAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
    [facebook requestWithGraphPath:@"me" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"meRequest", @"requestType", nil] andDelegate:self];
    
    [facebook requestWithGraphPath:@"me/likes" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myLikesRequest", @"requestType", nil] andDelegate:self];
//    NSString *myLikesURL = @"fql?q=SELECT page_id FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE type in ('MUSICIAN/BAND', 'MOVIE', 'TV SHOW', 'TV CHANNEL', 'TV NETWORK', 'BOOK') and uid =me())";
//    NSString *myLikesRequest = [myLikesURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    [facebook requestWithGraphPath:myLikesRequest andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myLikesRequest", @"requestType", nil] andDelegate:self];
    
    [facebook requestWithGraphPath:@"me/friends" andParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"myFriendsRequest", @"requestType", nil] andDelegate:self];
    
//    NSString *myFriends = @"SELECT uid2 from friend where uid1 = me()";
//    NSString *myFriendsPages = @"SELECT uid, page_id FROM page_fan WHERE type in ('MUSICIAN/BAND', 'MOVIE', 'TV SHOW', 'TV CHANNEL', 'TV NETWORK', 'BOOK') and uid in (select uid2 from #myFriendsQuery) order by uid";
//    NSString *fqlStatement = [NSString stringWithFormat:@"{\"myFriendsQuery\":\"%@\",\"myFriendsPagesQuery\":\"%@\"}",myFriends,myFriendsPages];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fqlStatement, @"queries", @"myFriendsLikesRequest", @"requestType", nil];
//    [facebook requestWithMethodName:@"fql.multiquery" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
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
    
    if (self.doneProcessing) {
        RFriend *friend = [self.mySortedFriendsAndScores objectAtIndex:indexPath.row];
        
        NSString* friendFBID = friend.friendID;
        NSString* profilePicURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",friendFBID];
        UIImage *profilePic = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePicURL]]];

        cell.imageView.image = profilePic;
        cell.imageView.layer.cornerRadius = 8.0;
        cell.imageView.layer.masksToBounds = YES;
        cell.nameLabel.text = friend.name;
        
        NSString* commonLikes = @"";
        int likeCounter = 0;
        for (NSString* pageID in friend.commonLikes) {
            if (likeCounter < 5) {
                NSString* likeName = [self.pageIdToName objectForKey:pageID];
                commonLikes = [NSString stringWithFormat:@"%@, %@",commonLikes,likeName];
                likeCounter++;
            }
        }
        commonLikes = [commonLikes substringWithRange:NSMakeRange(2,[commonLikes length]-2)];
        cell.similaritiesLabel.text = commonLikes;
        
        cell.compatibilityPercent.text = [NSString stringWithFormat:@"%.f", friend.compatScore*100];
        cell.percentSign.text = @"%";
    }
    
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
