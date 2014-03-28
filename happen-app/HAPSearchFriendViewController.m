//
//  HAPSearchFriendViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 2/26/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPSearchFriendViewController.h"


@interface HAPSearchFriendViewController ()

@property (strong, nonatomic) NSMutableArray *friendSearchResults;

@end

@implementation HAPSearchFriendViewController

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
}

- (NSMutableArray *)friendSearchResults {
    if (!_friendSearchResults) {
        _friendSearchResults = [[NSMutableArray alloc] init];
    }
    
    return _friendSearchResults ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.friendSearchResults) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.friendSearchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
//    cell.textLabel.text = [self.resultVenues[indexPath.row] name];
//    venue = self.resultVenues[indexPath.row];
    NSLog(@"call made");
    PFObject *user = self.friendSearchResults[indexPath.row];
    NSString *firstName = [user objectForKey:@"firstName"];
    NSString *lastName = [user objectForKey:@"lastName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    // And Profile picture
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    CALayer *imageLayer = cell.imageView.layer;
    //    [imageLayer setCornerRadius:cell.imageView.frame.size.height/2];
    //    [imageLayer setMasksToBounds:YES];
    
    //cell.imageView.file = [user objectForKey:self.imageKey];
    
    HAPRequestFriendButton *requestFriendButton = [[HAPRequestFriendButton alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
    requestFriendButton.user = (PFUser *)user;
    [requestFriendButton setTitle:@"Add" forState:UIControlStateNormal];
    [requestFriendButton setBackgroundColor:[UIColor blueColor]];
    [cell addSubview:requestFriendButton];
    [requestFriendButton addTarget:self action:@selector(requestFriend:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

- (IBAction)requestFriend:(id)sender {
    HAPRequestFriendButton *friendRequestButton = (HAPRequestFriendButton *)sender;
    PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
    [request setObject:[PFUser currentUser] forKey:@"source"];
    [request setObject:friendRequestButton.user forKey:@"target"];
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchForFriend:searchText];
//    NSLog(@"text changed");
}

-(void)searchForFriend: (NSString *)input {
//    NSLog(@"%@", input);
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    PFQuery *query = [PFUser query];

    [query whereKey:@"firstName" equalTo:input];
    
    
    [query orderByAscending:@"firstName"];
  
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            self.friendSearchResults = [objects mutableCopy];
            for (PFObject *object in self.friendSearchResults) {
                NSLog(@"%@", object.objectId);
            }
            [[self.searchDisplayController searchResultsTableView] reloadData];
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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
