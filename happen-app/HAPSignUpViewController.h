//
//  HAPSignUpViewController.h
//  happen-app
//
//  Created by Jack Okerman on 1/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@class HAPSignUpViewController;

@protocol SignUpViewContollerDelegate <NSObject>

//- (void)signUpViewControllerDidCancel:(HAPSignUpViewController *)controller;
- (void)signUpViewControllerDidSignUp:(HAPSignUpViewController *)controller;

@end

@interface HAPSignUpViewController : UITableViewController

@property (weak, nonatomic) id <SignUpViewContollerDelegate> delegate;

@end
