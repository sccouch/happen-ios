//
//  HAPMyFeedViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/6/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFeedViewController.h"

@implementation HAPFeedViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSMutableArray *initialViewController = [NSMutableArray array];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"FriendsFeedView"]];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"MeTooFeedView"]];
    
    self.viewController = initialViewController;
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query whereKey:@"target" equalTo:[PFUser currentUser]];
    [query whereKey:@"isUnread" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count >0) {
                NSString *count = [NSString stringWithFormat: @"%d", (int)objects.count];
                [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:count];
            }
        }
    }];
    
}

@end
