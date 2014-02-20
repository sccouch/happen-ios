//
//  HAPSelectEventTimeViewController.h
//  happen-app
//
//  Created by Jack Okerman on 2/19/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAPSelectEventTimeViewController;

@protocol SelectEventTimeViewContollerDelegate <NSObject>

- (void)selectEventTimeViewController: (HAPSelectEventTimeViewController *)controller DidSelectTime:(NSString *)time;

@end

@interface HAPSelectEventTimeViewController : UITableViewController

@property (weak, nonatomic) id<SelectEventTimeViewContollerDelegate> delegate;

@end
