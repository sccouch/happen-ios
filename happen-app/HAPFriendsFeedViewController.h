//
//  HAPFeedViewController.h
//  happen-app
//
//  Created by Jack Okerman on 1/29/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+NXEmptyView.h"
#import "Parse/Parse.h"
#import "HAPAddEventViewController.h"
#import "MCSwipeTableViewCell.h"

@interface HAPFriendsFeedViewController : PFQueryTableViewController <MCSwipeTableViewCellDelegate, AddEventViewContollerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;
@property (weak, nonatomic) PFObject *selectedObject;
@property (nonatomic, strong) MCSwipeTableViewCell *prototypeCell;

@end
