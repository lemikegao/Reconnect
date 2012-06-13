//
//  ReconnectTabControllerViewController.h
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "LoginViewController.h"

@interface ReconnectTabControllerViewController : UITabBarController <FBSessionDelegate, FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *greeting;
@property (weak, nonatomic) IBOutlet UILabel *myLike;
@property (weak, nonatomic) IBOutlet UILabel *friendLike;
- (IBAction)logoutOfFacebook:(id)sender;

@end
