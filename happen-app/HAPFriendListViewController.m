//
//  HAPFriendListViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 2/25/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFriendListViewController.h"
#import "HAPFriendEventListViewController.h"
#import "UITableView+NXEmptyView.h"
#import "HAPFriendsCell.h"

@interface HAPFriendListViewController ()

@end

@implementation HAPFriendListViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"firstName";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        self.imageKey = @"profilePic";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.nxEV_emptyView = self.emptyView;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    //PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //[query whereKey:@"creator" equalTo:[PFUser currentUser]];
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"friends"];
    PFQuery *query = [relation query];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"firstName"];
    
    return query;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"HAPFriendsCell";
    
    HAPFriendsCell *cell = (HAPFriendsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HAPFriendsCell alloc] init];
    }
    
    // Configure the cell
    
    // With Friend Name
    NSString *firstName = [object objectForKey:self.textKey];
    NSString *lastName = [object objectForKey:@"lastName"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // With Username
    NSString *username = [object objectForKey:@"username"];
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", username];
    
    // And Profile picture
    
    cell.profilePicView.contentMode = UIViewContentModeScaleAspectFit;
    //cell.profilePicView.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    PFFile *imageFile = [object objectForKey:@"profilePic"];
    CALayer *imageLayer = cell.profilePicView.layer;
    [imageLayer setCornerRadius:cell.profilePicView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        if (!error) {
            cell.profilePicView.image = [UIImage imageWithData:data];
        }
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check that a new transition has been requested to the DetailViewController and prepares for it
    if ([segue.identifier isEqualToString:@"FriendEventList"]){
        
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        HAPFriendEventListViewController *detailViewController = [segue destinationViewController];
        detailViewController.friend = object;
    }
}

@end
