//
//  ReconnectNavigationController.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "ReconnectNavigationController.h"

@implementation ReconnectNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{ 
    // try to do this manually instead of w photo
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationBar setTintColor:[UIColor colorWithRed:1.0f green:0.97f blue:0.73f alpha:0]];
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIColor blackColor], UITextAttributeTextShadowColor, [UIFont fontWithName:@"Futura-Medium-Italic" size:5.0f], UITextAttributeFont, nil]];
    
    return [super initWithRootViewController:rootViewController];

}

- (void) awakeFromNib
{
[super awakeFromNib];
    // try to do this manually instead of with photo
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];

//    [self.navigationBar setTintColor:[UIColor colorWithRed:1.0f green:0.97f blue:0.73f alpha:0]];
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIColor blackColor], UITextAttributeTextShadowColor, [UIFont fontWithName:@"Futura-Medium-Italic" size:5.0f], UITextAttributeFont, nil]];
}

@end
