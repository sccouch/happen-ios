//
//  HAPNewsViewController.m
//  happen-app
//
//  Created by Sam Couch on 2/26/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPNewsViewController.h"

@implementation HAPNewsViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSMutableArray *initialViewController = [NSMutableArray array];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"NewsView"]];
    [initialViewController addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"FriendRequestView"]];
    
    self.viewController = initialViewController;
}

@end
