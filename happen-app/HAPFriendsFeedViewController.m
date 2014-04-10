//
//  HAPFeedViewController.m
//  happen-app
//
//  Created by Jack Okerman on 1/29/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFeedCell.h"
#import "HAPFriendsFeedViewController.h"


@implementation HAPFriendsFeedViewController


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
    
    if (self.objects.count == 0) {
        NSLog(@"No friends");
        
        UIImage *image = [UIImage imageNamed:@"logo.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        // Add image view on top of table view
        [self.tableView addSubview:imageView];
        
        // Set the background view of the table view
        self.tableView.backgroundView = imageView;
        [self.tableView setHidden:YES];
    }
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     
     // Query for friends
     PFRelation *relation = [[PFUser currentUser] relationForKey:@"friends"];
     PFQuery *friends = [relation query];
     
     // Query for events created by friends
     PFQuery *friendsEventsQuery = [PFQuery queryWithClassName:self.parseClassName];
     [friendsEventsQuery whereKey:@"creator" matchesQuery:friends];
     
     [friendsEventsQuery whereKey:@"meToos" notEqualTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
     [friendsEventsQuery whereKey:@"hides" notEqualTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];

     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
     friendsEventsQuery.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
     friendsEventsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     
     [friendsEventsQuery includeKey:@"creator"];
     [friendsEventsQuery orderByDescending:@"createdAt"];
     
     return friendsEventsQuery;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

//     static NSString *CellIdentifier = @"HAPFeedCell";
//     //PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//     HAPFeedCell *cell = (HAPFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//     if (cell == nil) {
//     //cell = [[HAPFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//     cell = [[HAPFeedCell alloc] init];
//     }

     static NSString *CellIdentifier = @"HAPSwipeCell";
     
     MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell == nil) {
         cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
         cell = [[MCSwipeTableViewCell alloc] init];
     }
     
     //UIView *checkView = [self viewWithImageName:@"check"];
     UIView *checkView = [self viewWithText:@"me too"];
     UIColor *greenColor = [UIColor colorWithRed:100.0 / 205.0 green:197.0 / 255.0 blue:157.0 / 255.0 alpha:1.0];
     
     UIView *crossView = [self viewWithText:@"hide"];
     UIColor *redColor = [UIColor colorWithRed:244.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
     //UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

     
     [cell setDelegate:self];
     
     // Configure the cell

      cell.eventLabel.text = [object objectForKey:self.textKey];
      PFUser *friend = [object objectForKey:@"creator"];
 
      NSString *firstName = [friend objectForKey:@"firstName"];
      NSString *lastName = [friend objectForKey:@"lastName"];
 
      //cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
      NSString *fullName = [NSString stringWithFormat:@"%@ %@ ", firstName, lastName];
      NSString *username = [NSString stringWithFormat:@" @%@",[friend objectForKey:@"username"]];
      NSUInteger length = [username length];
     
      //UIFont *nameFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0];
      UIFont *nameFont = [UIFont boldSystemFontOfSize:17];
     
      NSDictionary *nameDict = [NSDictionary dictionaryWithObject: nameFont forKey:NSFontAttributeName];
      NSMutableAttributedString *nameAttrString = [[NSMutableAttributedString alloc] initWithString:fullName attributes: nameDict];
     
      UIFont *usernameFont = [UIFont systemFontOfSize:12];
      NSDictionary *usernameDict = [NSDictionary dictionaryWithObject:usernameFont forKey:NSFontAttributeName];
      NSMutableAttributedString *usernameAttrString = [[NSMutableAttributedString alloc]initWithString:username attributes:usernameDict];
      [usernameAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:(NSMakeRange(0, length))];
     
      [nameAttrString appendAttributedString:usernameAttrString];
     
      cell.nameLabel.attributedText = nameAttrString;
     
     
      cell.profilePicView.contentMode = UIViewContentModeScaleAspectFit;
 
      cell.profilePicView.image = [UIImage imageNamed:@"placeholder.jpg"];
      PFFile *imageFile = [friend objectForKey:@"profilePic"];
      CALayer *imageLayer = cell.profilePicView.layer;
      [imageLayer setCornerRadius:cell.profilePicView.frame.size.width/2];
      [imageLayer setMasksToBounds:YES];
      [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
          // Now that the data is fetched, update the cell's image property.
         cell.profilePicView.image = [UIImage imageWithData:data];
      }];
     
     cell.shouldAnimateIcons = YES;
     
     [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
         //NSLog(@"Did swipe \"Me Too\" cell");
         
         [self meTooAtIndexPath:indexPath];
         
     }];
  
     [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3
           completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
         //NSLog(@"Did swipe \"Hide\" cell");
         
               [self hideAtIndexPath:indexPath];
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

#pragma mark - UITableViewDelegate

- (void)meTooAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedObject = [self objectAtIndexPath:indexPath];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query includeKey:@"creator"];
    
    [query whereKey:@"objectId" equalTo: [_selectedObject objectId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFObject *event = object;
                PFRelation *meToos = [event relationForKey:@"meToos"];
                
                [meToos addObject:[PFUser currentUser]];
                [event saveInBackground];
                
                
                PFObject *news = [PFObject objectWithClassName:@"News"];
                [news setObject:[PFUser currentUser] forKey:@"source"];
                [news setObject:[event objectForKey:@"creator"] forKey:@"target"];
                [news setObject:event forKey:@"event"];
                [news setValue:@"ME_TOO" forKey:@"type"];
                [news setObject:[NSNumber numberWithBool:YES]  forKey:@"isUnread"];
                [news saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self loadObjects];
                }];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)hideAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedObject = [self objectAtIndexPath:indexPath];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query includeKey:@"creator"];
    
    [query whereKey:@"objectId" equalTo: [_selectedObject objectId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFObject *event = object;
                PFRelation *hides = [event relationForKey:@"hides"];
                
                [hides addObject:[PFUser currentUser]];
                [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self loadObjects];
                }];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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

//- (void)reload:(id)sender {
//    _nbItems = kMCNumItems;
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//- (void)deleteCell:(MCSwipeTableViewCell *)cell {
//    NSParameterAssert(cell);
//    
//    _nbItems--;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (UIView *)viewWithText:(NSString *)textName {
    UIView *textView = [[UIView alloc] init];
    CGRect bounds;
    
    if ([textName isEqual: @"me too"]) {
        bounds = CGRectMake(-35, -27, 75, 50);
    }
    if ([textName isEqual: @"hide"]) {
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
