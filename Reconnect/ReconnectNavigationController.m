//
//  ReconnectNavigationController.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectNavigationController.h"
#import <QuartzCore/CALayer.h>

@implementation ReconnectNavigationController

- (void)customizeNavigationBar {
    // try to do this manually instead of with photo
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];
    
    CGRect titleFrame = CGRectMake(0, 0, 320, 32);
    UILabel *label = [[UILabel alloc] initWithFrame:titleFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura-Medium" size:24.0f];
    label.text = @"SIMILAR FRIENDS";
    [self.navigationBar addSubview:label];
    
    CGRect subtitleFrame = CGRectMake(0,29,320,12);
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.textAlignment = UITextAlignmentCenter;
    subtitleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:12.0f];
    subtitleLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    subtitleLabel.text = @"LAST 30 DAYS";
    [self.navigationBar addSubview:subtitleLabel];
    
    [self.navigationBar setTintColor:[UIColor colorWithRed:1.0f green:0.97f blue:0.73f alpha:0]];
    self.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationBar.layer.shadowRadius = 3.0f;
    self.navigationBar.layer.shadowOpacity = 1.0f; 
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{ 
    [self customizeNavigationBar];
    return [super initWithRootViewController:rootViewController];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self customizeNavigationBar];
}

@end
