//
//  HAPAddEventViewController.h
//  happen-app
//
//  Created by Jack Okerman on 2/13/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@class HAPAddEventViewController;


@protocol AddEventViewContollerDelegate <NSObject>

- (void)addEventViewContollerDidAdd:(HAPAddEventViewController *)controller;

@end

@interface HAPAddEventViewController : UITableViewController

@property (weak, nonatomic) id<AddEventViewContollerDelegate> delegate;

@end
