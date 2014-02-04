//
//  HAPLoginViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/3/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPLoginViewController.h"

@interface HAPLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation HAPLoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.usernameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    if ([self requiredFieldsBlank]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Required fields must not be left blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = TAG_BLANK;
        [alert show];
    }
    else {
        [self loginUser:[self getLoginInfo]];
    }
}

- (BOOL)requiredFieldsBlank {
    return ([self.usernameField.text isEqualToString:@""]
            || [self.passwordField.text isEqualToString:@""]);
}

- (NSMutableDictionary *)getLoginInfo {
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setObject:self.usernameField.text forKey:@"username"];
    [loginInfo setObject:self.passwordField.text forKey:@"password"];
    return loginInfo;
}

- (void)loginUser:(NSMutableDictionary *)loginInfo {
    [PFUser logInWithUsernameInBackground:[loginInfo objectForKey:@"username"] password:[loginInfo objectForKey:@"password"] block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier: @"OpenFeedView" sender: self];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid login information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = TAG_ERROR;
            [alert show];
        }
    }];
}

- (void)clearLoginInfo {
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_BLANK) {
        [self.usernameField becomeFirstResponder];
    }
    else if (alertView.tag == TAG_ERROR) {
        [self clearLoginInfo];
        [self.usernameField becomeFirstResponder];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenFeedView"]) {
        
    }
}

@end
