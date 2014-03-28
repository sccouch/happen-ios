//
//  HAPFeedViewController.h
//  happen-app
//
//  Created by Jack Okerman on 1/29/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface HAPFriendsFeedViewController : PFQueryTableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) PFObject *selectedObject;

@end
