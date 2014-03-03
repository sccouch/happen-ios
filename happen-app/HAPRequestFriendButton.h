//
//  HAPRequestFriendButton.h
//  happen-app
//
//  Created by Jack Okerman on 3/3/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPRequestFriendButton : UIButton

@property (weak, nonatomic) PFUser *user;

@end
