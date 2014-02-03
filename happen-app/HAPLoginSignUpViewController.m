//
//  HAPLoginSignUpViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/3/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPLoginSignUpViewController.h"

@interface HAPLoginSignUpViewController ()

@end

@implementation HAPLoginSignUpViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignUp"]) {
        HAPSignUpViewController *signUpViewController = segue.destinationViewController;
        signUpViewController.delegate = self;
    }
}

- (void)signUpViewControllerDidSignUp:(HAPSignUpViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
