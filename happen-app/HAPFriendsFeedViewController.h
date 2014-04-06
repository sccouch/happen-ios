//
//  HAPFeedViewController.h
//  happen-app
//
//  Created by Jack Okerman on 1/29/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "MCSwipeTableViewCell.h"

@interface HAPFriendsFeedViewController : PFQueryTableViewController <MCSwipeTableViewCellDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;
@property (weak, nonatomic) PFObject *selectedObject;

@end
