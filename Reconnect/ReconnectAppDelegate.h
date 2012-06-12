//
//  ReconnectAppDelegate.h
//  Reconnect
//
//  Created by Michael Gao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface ReconnectAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Facebook *facebook;

@end
