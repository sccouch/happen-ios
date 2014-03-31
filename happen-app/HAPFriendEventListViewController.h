//
//  HAPFriendEventListViewController.h
//  happen-app
//
//  Created by Kalyn Nakano on 3/31/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPFriendEventListViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) PFObject *friend;

@end
