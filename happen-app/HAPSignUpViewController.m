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

- (IBAction)joinButtonPressed:(id)sender {
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:self.firstNameField.text forKey:@"firstName"];
    [userInfo setObject:self.lastNameField.text forKey:@"lastName"];
    [userInfo setObject:self.usernameField.text forKey:@"username"];
    [userInfo setObject:self.passwordField.text forKey:@"password"];
    [userInfo setObject:self.confirmPasswordField.text forKey:@"confirmPassword"];
    
    if ([self userInfoisValid:userInfo]) {
        NSLog(@"%@", @"User info is valid");
//        [self signUpUser: userInfo];
    }
    else
        NSLog(@"%@", @"User info is invald.");
}

- (BOOL)userInfoisValid:(NSMutableDictionary*)userInfo {
    if ([[userInfo objectForKey:@"firstName"] isEqualToString:@""]
        || [[userInfo objectForKey:@"lastName"] isEqualToString:@""]
        || [[userInfo objectForKey:@"username"] isEqualToString:@""]
        || [[userInfo objectForKey:@"password"] isEqualToString:@""]
        || [[userInfo objectForKey:@"confirmPassword"] isEqualToString:@""]) {
            return NO;
        }
    
    if (![[userInfo objectForKey:@"password"] isEqualToString: [userInfo objectForKey:@"confirmPassword"]]) {
        return NO;
    }
    
    return YES;
}

- (void)signUpUser:(NSMutableDictionary*)userInfo {
    PFUser *user = [PFUser user];
    user.username = [userInfo objectForKey:@"username"];
    user.password = [userInfo objectForKey:@"password"];
    
    user[@"firstName"] = [userInfo objectForKey:@"firstName"];
    user[@"lastName"] = [userInfo objectForKey:@"lastName"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"%@", @"User created successfully");
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
    }];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
