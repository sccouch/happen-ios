//
//  HAPSignUpViewController.m
//  happen-app
//
//  Created by Jack Okerman on 1/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPSignUpViewController.h"

@interface HAPSignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@end

@implementation HAPSignUpViewController

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
    [self.firstNameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonPressed:(id)sender {
    if ([self requiredFieldsBlank]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Required fields must not be left blank." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = TAG_BLANK;
        [alert show];
    }
    else if (![self passwordsMatch]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The passwords you entered do not match." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = TAG_PASSWORDS;
        [alert show];
    }
    else {
        [self signUpUser:[self getUserInfo]];
    }
}

- (BOOL)requiredFieldsBlank {
    return ([self.firstNameField.text isEqualToString:@""]
            || [self.lastNameField.text isEqualToString:@""]
            || [self.usernameField.text isEqualToString:@""]
            || [self.passwordField.text isEqualToString:@""]
            || [self.confirmPasswordField.text isEqualToString:@""]);
}

- (BOOL)passwordsMatch {
    return ([self.passwordField.text isEqualToString:self.confirmPasswordField.text]);
}

- (NSMutableDictionary *)getUserInfo {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:self.firstNameField.text forKey:@"firstName"];
    [userInfo setObject:self.lastNameField.text forKey:@"lastName"];
    [userInfo setObject:self.usernameField.text forKey:@"username"];
    [userInfo setObject:self.passwordField.text forKey:@"password"];
    [userInfo setObject:self.confirmPasswordField.text forKey:@"confirmPassword"];
    return userInfo;
}

- (void)signUpUser:(NSMutableDictionary*)userInfo {
    PFUser *user = [PFUser user];
    user.username = [userInfo objectForKey:@"username"];
    user.password = [userInfo objectForKey:@"password"];
    
    user[@"firstName"] = [userInfo objectForKey:@"firstName"];
    user[@"lastName"] = [userInfo objectForKey:@"lastName"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your user account was created successfully." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            alert.tag = TAG_SUCCESS;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error creating you user account" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            alert.tag = TAG_ERROR;
            [alert show];
        }
    }];
}

- (void)clearUserInfo {
    self.firstNameField.text = @"";
    self.lastNameField.text = @"";
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.confirmPasswordField.text = @"";
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_BLANK) {}
    else if (alertView.tag == TAG_PASSWORDS) {
        self.passwordField.text = @"";
        self.confirmPasswordField.text = @"";
        [self.passwordField becomeFirstResponder];
        
    }
    else if (alertView.tag == TAG_SUCCESS) {
        [self userDidSignUp];
    }
    else if (alertView.tag == TAG_ERROR) {
        [self clearUserInfo];
        [self.firstNameField becomeFirstResponder];
    }
}

- (void)userDidSignUp {
    [self.delegate signUpViewControllerDidSignUp:self];
}

@end
