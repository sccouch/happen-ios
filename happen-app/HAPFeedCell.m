//
//  HAPFeedCell.m
//  happen-app
//
//  Created by Kalyn Nakano on 3/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFeedCell.h"

@implementation HAPFeedCell

@synthesize nameLabel = _nameLabel;
@synthesize eventLabel = _eventLabel;
@synthesize profilePicView = _profilePicView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.nameLabel.text = @"Kalyn Nakano";
        self.eventLabel.text = @"travel to NYC";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
