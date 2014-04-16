//
//  HAPMyListViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/13/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPMyListViewController.h"


@interface HAPMyListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;

@end

@implementation HAPMyListViewController

NSData *imageData;
@synthesize profilePicButton = _profilePicButton;

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

- (IBAction)profilePicButtonClicked:(id)sender {
    //If the device has a camera, allow a choice via an action sheet
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"Device has a camera, will show ActionSheet for a choice");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                 delegate: self
                                                        cancelButtonTitle: @"Cancel"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles: @"Take Photo",
                                      @"Choose Existing Photo", nil];
        [actionSheet showFromRect: _profilePicButton.frame inView: _profilePicButton.superview animated: YES];
    } else {
        NSLog(@"Device does not have a camera, will show gallery");
        //otherwise, if it doesn't have a camera, just go ahead and show the picker
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Show the picker but only from whatever choice the user made
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    NSString *buttonTitleAtButtonIndex = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitleAtButtonIndex isEqualToString:@"Take Photo"]) {
        // take photo...
        NSLog(@"User decided to take a photo");
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else if ([buttonTitleAtButtonIndex isEqualToString:@"Choose Existing Photo"]) {
        // choose existing photo...
        NSLog(@"User decided to pick from the gallery");
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    NSLog(@"imagePickerControllerDidCancel called");
    [Picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo called");
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    float actualHeight = 200.0;
    float actualWidth = 200.0;
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [selectedImage drawInRect:rect];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Dismiss the picker
    [Picker dismissViewControllerAnimated:YES completion:nil];
    
    // Get a path to the local documents directory
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pathToProfilePicture = [NSString pathWithComponents:[NSArray arrayWithObjects:documentsDirectory, @"userprofilepicture", nil]];
    
    // Delete the local profile picture, if one exists already
    BOOL profilePictureFileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathToProfilePicture];
    if (profilePictureFileExists) {
        NSLog(@"User profile picture exists, we will delete it now");
        [[NSFileManager defaultManager] removeItemAtPath:pathToProfilePicture error:nil];
    }
    
    // Create the file
    BOOL createdFileOk = [[NSFileManager defaultManager] createFileAtPath:pathToProfilePicture contents:nil attributes:nil];
    if (!createdFileOk) {
        NSLog(@"Error creating profile picture image file to write to on disk %@", pathToProfilePicture);
    } else {
        NSLog(@"Writing profile picture image file to disk...");
        NSFileHandle* profilePictureHandle = [NSFileHandle fileHandleForWritingAtPath:pathToProfilePicture];
        [profilePictureHandle writeData:UIImagePNGRepresentation(croppedImage)];
        [profilePictureHandle closeFile];
        NSLog(@"Writing profile picture complete");
        
        // Show the profile pic
        [self.profilePicButton setImage:croppedImage forState:UIControlStateNormal];
        CALayer *imageLayer = self.profilePicButton.layer;
        [imageLayer setCornerRadius:self.profilePicButton.frame.size.width/2];
        [imageLayer setMasksToBounds:YES];
        imageData = UIImagePNGRepresentation(croppedImage);
        
        
        //[self.profilePicButton setTitle: @"Edit photo" forState:UIControlStateHighlighted];
        
        PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:imageData];
        [imageFile saveInBackground];
        
        PFUser *user = [PFUser currentUser];
        //user[@"profilePic"] = imageFile;
        [user setObject: imageFile forKey:@"profilePic"];
        [user saveInBackground];
        
    }
    
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    PFUser *user = [PFUser currentUser];
    
    PFFile *userImageFile = user[@"profilePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self.profilePicButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        }
    }];
    
    self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.width/2;
    self.profilePicButton.layer.masksToBounds = YES;
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
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    [query includeKey:@"MeToos"];
    
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

    static NSString *CellIdentifier = @"HAPSwipeCell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell = [[MCSwipeTableViewCell alloc] init];
    }
    
    UIView *crossView = [self viewWithText:@"delete"];
    UIColor *redColor = [UIColor colorWithRed:244.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
    //UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    
    [cell setDelegate:self];
    
    cell.eventLabel.text = [object objectForKey:self.textKey];
    
    int count = [[object objectForKey:@"meTooCount"] intValue];
    if (count != 0) {
        NSString *meTooCount = [NSString stringWithFormat:@"+%d", count];
        cell.meTooCount.text = meTooCount;
    }
    else {
        cell.meTooCount.hidden = YES;
    }

    cell.shouldAnimateIcons = YES;
 
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      //NSLog(@"Did swipe \"Hide\" cell");
                      
                      [self deleteAtIndexPath:indexPath];
                  }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        HAPAddEventViewController *addEventViewController = [navigationController viewControllers][0];
        addEventViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"ViewDetails"]) {
        // Capture the object (e.g. exam) the user has selected from the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        HAPEventDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.selectedEvent = object;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)addEventViewContollerDidAdd:(HAPAddEventViewController *)controller {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self loadObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject* update = [self.objects objectAtIndex:indexPath.row];
    NSString *text = [update objectForKey:@"details"];
    
    if ([text length] > 33) {
        return 65;
    }
    else {
        return 50;
    }

}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)deleteAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedObject = [self objectAtIndexPath:indexPath];
   
    [PFCloud callFunctionInBackground:@"deleteEvent"
                       withParameters:@{@"eventId": [_selectedObject objectId]/*objectID of event*/}
                                block:^(NSString *unused, NSError *error) {
                                    if (!error) {
                                        //NSLog(@"cloud code worked");
                                        [self loadObjects];
                                    }
                                }];
    
}

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
    
    if ([textName isEqual: @"delete"]) {
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
