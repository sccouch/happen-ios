//
//  HAPFriendRequestTableViewController.m
//  happen-app
//
//  Created by Sam Couch on 2/26/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFriendRequestTableViewController.h"
#import "HAPFriendsCell.h"

@interface HAPFriendRequestTableViewController ()

@end

@implementation HAPFriendRequestTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"FriendRequest";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"objectId";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    NSString *count = [NSString stringWithFormat: @"%d", (int)self.objects.count];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:count];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"target" equalTo:[PFUser currentUser]];
    [query includeKey:@"source"];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"HAPFriendsCell";
    
    HAPFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HAPFriendsCell alloc] init];
    }
    
    // Configure the cell
    PFUser *source = [object objectForKey:@"source"];
    
    // With Source Name
    NSString *firstName = [source objectForKey:@"firstName"];
    NSString *lastName = [source objectForKey:@"lastName"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // With Source Username
    NSString *username = [source objectForKey:@"username"];
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", username];
    
    // And Profile picture
    cell.profilePicView.contentMode = UIViewContentModeScaleAspectFit;
    cell.profilePicView.image = [UIImage imageNamed:@"placeholder.jpg"];
    PFFile *imageFile = [source objectForKey:@"profilePic"];
    CALayer *imageLayer = cell.profilePicView.layer;
    [imageLayer setCornerRadius:cell.profilePicView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        cell.profilePicView.image = [UIImage imageWithData:data];
    }];

    // Accept Button
    cell.acceptButton.objectId = object.objectId;
    [cell.acceptButton addTarget:self
                        action:@selector(acceptFriendRequest:)
              forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)acceptFriendRequest:(id)sender {
    HAPAcceptFriendButton *acceptFriendButton = (HAPAcceptFriendButton *)sender;
    [PFCloud callFunctionInBackground:@"acceptFriendRequest"
                       withParameters:@{@"friendRequest": acceptFriendButton.objectId}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        [self loadObjects];
                                    }
                                }];
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
