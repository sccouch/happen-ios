//
//  HAPLoginSignUpViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/3/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPLoginSignUpViewController.h"

@interface HAPLoginSignUpViewController ()
@property (strong, nonatomic) IBOutlet UILabel *appName;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

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
    
    UIFont *semibold = [UIFont fontWithName:@"ProximaNova-Semibold" size:15];
    UIFont *regular = [UIFont fontWithName:@"ProximaNova-Semibold" size:13];
    NSString *appNameString = @"HAPPEN";
    NSString *loginButtonString = @"LOG IN";
    NSString *signupButtonString = @"SIGN UP";
    
    NSAttributedString *attributedString =
    [[NSAttributedString alloc]
     initWithString:appNameString
     attributes:
     @{
       NSFontAttributeName : semibold,
       NSKernAttributeName : @(+4.0f)
       }];
    
    self.appName.attributedText = attributedString;
    
    NSAttributedString *attributedLogInString =
    [[NSAttributedString alloc]
     initWithString:loginButtonString
     attributes:
     @{
       NSFontAttributeName : regular,
       NSKernAttributeName : @(+2.0f)
       }];
    
    [self.loginButton setAttributedTitle:attributedLogInString forState:UIControlStateNormal];
    
    NSAttributedString *attributedSignUpString =
    [[NSAttributedString alloc]
     initWithString:signupButtonString
     attributes:
     @{
       NSFontAttributeName : regular,
       NSKernAttributeName : @(+2.0f)
       }];
    
    [self.signupButton setAttributedTitle:attributedSignUpString forState:UIControlStateNormal];
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    
    
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
