//
//  RFriend.h
//  Reconnect
//
//  Created by Michael Gao on 6/13/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFriend : NSObject

@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableSet *commonLikes;
@property float compatScore;
@property int totalLikes;
@property int sameLikes;

@end
