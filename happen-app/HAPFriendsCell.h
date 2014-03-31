//
//  HAPFriendsCell.h
//  happen-app
//
//  Created by Kalyn Nakano on 3/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAPRequestFriendButton.h"
#import "HAPAcceptFriendButton.h"

@interface HAPFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet HAPRequestFriendButton *addButton;
@property (weak, nonatomic) IBOutlet HAPAcceptFriendButton *acceptButton;

@end
