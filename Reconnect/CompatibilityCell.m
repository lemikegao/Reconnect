//
//  CompatibilityCell.m
//  Reconnect
//
//  Created by Kimberly Hsiao on 6/12/12.
//  Copyright (c) 2012 Calimucho. All rights reserved.
//

#import "CompatibilityCell.h"
#import "Constants.h"

@implementation CompatibilityCell

@synthesize nameLabel = _nameLabel;
@synthesize similaritiesLabel = _similaritiesLabel;
@synthesize compatibilityPercent = _compatibilityPercent;
@synthesize percentSign = _percentSign;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews
{   
    [super layoutSubviews];
    
    // set alignment of friend's picture to top left of the table cell
    self.imageView.frame = CGRectMake(COMPATIBILITYPICMARGIN,
                                      COMPATIBILITYPICMARGIN,
                                      COMPATIBILITYPICWIDTH,
                                      COMPATIBILITYPICHEIGHT);
    
    self.nameLabel.frame = CGRectMake(COMPATIBILITYPICWIDTH + 2*COMPATIBILITYPICMARGIN,
                                      COMPATIBILITYPICMARGIN,
                                      COMPATIBILITYTEXTWIDTH,
                                      self.nameLabel.frame.size.height);
    
    self.similaritiesLabel.frame = CGRectMake(COMPATIBILITYPICWIDTH + 2*COMPATIBILITYPICMARGIN,
                                            3*COMPATIBILITYPICMARGIN,
                                            COMPATIBILITYTEXTWIDTH,
                                            self.similaritiesLabel.frame.size.height);
    
}


@end
