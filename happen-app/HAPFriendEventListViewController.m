//
//  HAPFriendEventListViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 3/31/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPFriendEventListViewController.h"

@interface HAPFriendEventListViewController ()

@end

@implementation HAPFriendEventListViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    PFUser *user = self.friend;
    
    PFFile *userImageFile = user[@"profilePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self.profilePicture setImage: [UIImage imageWithData:imageData]];
        }
    }];
    //    [imageLayer setCornerRadius:_profilePic.frame.size.width/2];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    self.profilePicture.layer.masksToBounds = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user[@"username"]];
    
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
    return 50;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"creator" equalTo:self.friend];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    static NSString *CellIdentifier = @"Cell";
//    
//    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Configure the cell
//    cell.textLabel.text = [object objectForKey:self.textKey];
//    cell.imageView.file = [object objectForKey:self.imageKey];
    static NSString *CellIdentifier = @"HAPSwipeCell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell = [[MCSwipeTableViewCell alloc] init];
    }
    
    //UIView *checkView = [self viewWithImageName:@"check"];
    UIView *checkView = [self viewWithText:@"me too"];
    UIColor *greenColor = [UIColor colorWithRed:100.0 / 255.0 green:197.0 / 255.0 blue:157.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithText:@"jk nvm"];
    UIColor *redColor = [UIColor colorWithRed:244.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
    //UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    [cell setDelegate:self];
    
    cell.meTooCheck.hidden = YES;
    
    //cell.eventLabel.text = [object objectForKey:self.textKey];
    // Configure the cell
    PFRelation *meToos = [object relationForKey:@"meToos"];
    NSMutableArray *likers = [NSMutableArray array];

    cell.eventLabel.text = [object objectForKey:self.textKey];
    PFQuery *friendQuery = meToos.query;
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *meTooers, NSError *error) {
        if (!error) {
            for (PFObject *meTooer in meTooers) {
                [likers addObject:[meTooer objectId]];
                //NSLog(@"%@", [meTooer objectForKey:@"firstName"]);
            }
            
            if ([likers containsObject:[[PFUser currentUser] objectId]]) {
                [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3
                              completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                                  //NSLog(@"Did swipe \"Hide\" cell");
                                  
                    [self unMeTooAtIndexPath:indexPath];
                }];
                cell.meTooCheck.hidden = NO;
            }
            
            else {
                [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                    //NSLog(@"Did swipe \"Me Too\" cell");
                    
                    [self meTooAtIndexPath:indexPath];
                    
                }];
            }
        }
        else {
            NSLog(@"ERRERE");
        }
    }];

    //[query whereKey:@"meToos" equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];

    cell.shouldAnimateIcons = YES;

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

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

- (void)unMeTooAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedObject = [self objectAtIndexPath:indexPath];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
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
