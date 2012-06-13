//
//  CompatibilityCell.h
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompatibilityCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* similaritiesLabel;
@property (nonatomic, weak) IBOutlet UILabel* compatibilityPercent;
@property (nonatomic, weak) IBOutlet UILabel* percentSign;

@end
