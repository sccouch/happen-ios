//
//  HAPAcceptFriendButton.h
//  happen-app
//
//  Created by Jack Okerman on 3/2/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPAcceptFriendButton : UIButton

@property (weak, nonatomic) NSString *objectId;
@property (weak, nonatomic) PFUser *user;

@end
