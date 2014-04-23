//
//  HAPFeedViewController.m
//  happen-app
//
//  Created by Jack Okerman on 1/29/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFeedCell.h"
#import "HAPMeTooFeedViewController.h"

@implementation HAPMeTooFeedViewController


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Event";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"details";
        
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
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableView.nxEV_emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView.nxEV_emptyView setBackgroundColor: [UIColor grayColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
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


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    // Query for friends
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query includeKey:@"creator"];
    
    [query orderByDescending:@"createdAt"];
    
    [query whereKey:@"MeToos" equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject* update = [self.objects objectAtIndex:indexPath.row];
    NSString *text = [update objectForKey:@"details"];
    
    if ([text length] > 32) {
        return 85;
    }
    else {
        return 70;
    }
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"HAPSwipeCell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[MCSwipeTableViewCell alloc] init];
    }
 
    UIView *crossView = [self viewWithText:@"jk nvm"];
    UIColor *redColor = [UIColor colorWithRed:244.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
    UIColor *grayColor = [UIColor colorWithRed:208.0 / 255.0 green:208.0 / 255.0 blue:208.0 / 255.0 alpha:1.0];
    
    [cell setDelegate:self];
    
    // Configure the cell
    
    [cell setDefaultColor:grayColor];
    
    cell.eventLabel.text = [object objectForKey:self.textKey];
    cell.timeFrame.text = [object objectForKey:@"timeFrame"];
    PFUser *friend = [object objectForKey:@"creator"];
    
    NSString *firstName = [friend objectForKey:@"firstName"];
    NSString *lastName = [friend objectForKey:@"lastName"];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@ ", firstName, lastName];
    cell.nameLabel.text = fullName;
     
    cell.profilePicView.contentMode = UIViewContentModeScaleAspectFit;
    
    //cell.profilePicView.image = [UIImage imageNamed:@"placeholder.jpg"];
    PFFile *imageFile = [friend objectForKey:@"profilePic"];
    CALayer *imageLayer = cell.profilePicView.layer;
    [imageLayer setCornerRadius:cell.profilePicView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        cell.profilePicView.image = [UIImage imageWithData:data];
    }];

    cell.shouldAnimateIcons = YES;
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      //NSLog(@"Did swipe \"Un Me Too\" cell");
                      
                      [self unMeTooAtIndexPath:indexPath];
                  }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
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

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)unMeTooAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedObject = [self objectAtIndexPath:indexPath];
    
    /*PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query includeKey:@"creator"];
    
    [query whereKey:@"objectId" equalTo: [_selectedObject objectId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFObject *event = object;
                PFRelation *meToos = [event relationForKey:@"meToos"];
                
                [meToos removeObject:[PFUser currentUser]];
                [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self loadObjects];
                }];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
    
    [PFCloud callFunctionInBackground:@"undoMeTooEvent"
                       withParameters:@{@"eventId": [_selectedObject objectId]}
                                block:^(NSString *unused, NSError *error) {
                                    if (!error) {
                                        //success
                                        //NSLog(@"cloud code worked");
                                        [self loadObjects];
                                    }
                                }];
    
}

#pragma mark - MCSwipeTableViewCellDelegate


// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    //NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    //NSLog(@"Did end swiping the cell!");
}

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage {
    //NSLog(@"Did swipe with percentage : %f", percentage);
}

#pragma mark - Utils

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (UIView *)viewWithText:(NSString *)textName {
    UIView *textView = [[UIView alloc] init];
    CGRect bounds;

    if ([textName isEqual: @"jk nvm"]) {
        bounds = CGRectMake(-25, -27, 75, 50);
    }
    UILabel *textLabel = [[UILabel alloc] initWithFrame:bounds];
    NSAttributedString *attributedString =
    [[NSAttributedString alloc]
     initWithString:textName
     attributes:
     @{
       NSFontAttributeName : [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18.0f],
       NSForegroundColorAttributeName : [UIColor whiteColor]
       }];
    textLabel.attributedText = attributedString;
    [textView addSubview:textLabel];
    textView.contentMode = UIViewContentModeCenter;
    return textView;
}


@end
