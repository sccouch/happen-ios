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
}

@end
