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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    if ([self.usernameField.text isEqualToString:@""]
        || [self.passwordField.text isEqualToString:@""]) {
        NSLog(@"%@", @"Username and password must not be left blank");
    }
    else {
        NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
        [loginInfo setObject:self.usernameField.text forKey:@"username"];
        [loginInfo setObject:self.passwordField.text forKey:@"password"];
        
    }
    
}

- (void)loginUser:(NSMutableDictionary *)loginInfo {
    [PFUser logInWithUsernameInBackground:[loginInfo objectForKey:@"username"] password:[loginInfo objectForKey:@"password"] block:^(PFUser *user, NSError *error) {
        if (user) {
            
        }
        else {
            
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
