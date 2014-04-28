//
//  HAPFriendListViewController.h
//  happen-app
//
//  Created by Kalyn Nakano on 2/25/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface HAPFriendListViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@end
