//
//  HAPFeedCell.h
//  happen-app
//
//  Created by Kalyn Nakano on 3/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPFeedCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *nameLabel;
@property(nonatomic,weak) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;



@end
