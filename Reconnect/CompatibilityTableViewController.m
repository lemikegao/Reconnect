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

@interface CompatibilityTableViewController ()

@end

@implementation CompatibilityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    cell.backgroundColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];
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
