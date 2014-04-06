//
//  HAPMeTooFeedViewController.h
//  happen-app
//
//  Created by Jack Okerman on 3/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MCSwipeTableViewCell.h"

@interface HAPMeTooFeedViewController : PFQueryTableViewController <MCSwipeTableViewCellDelegate>
@property (weak, nonatomic) PFObject *selectedObject;
@end
