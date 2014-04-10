//
//  HAPMyListViewController.h
//  happen-app
//
//  Created by Jack Okerman on 2/13/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <Parse/Parse.h>
#import "HAPAddEventViewController.h"
#import "MCSwipeTableViewCell.h"

@interface HAPMyListViewController : PFQueryTableViewController<AddEventViewContollerDelegate, MCSwipeTableViewCellDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) PFObject *selectedObject;

@end
