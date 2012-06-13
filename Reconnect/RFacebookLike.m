//
//  RFacebookLike.m
//  Reconnect
//
//  Created by Michael Gao on 6/13/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "RFacebookLike.h"

@implementation RFacebookLike

@synthesize id = _id;
@synthesize name = _name;

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"id: %@; name: %@", self.id, self.name];
    
    return descriptionString;
}

@end
