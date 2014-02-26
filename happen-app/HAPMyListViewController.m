//
//  HAPMyListViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/13/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPMyListViewController.h"

@interface HAPMyListViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;

@end

@implementation HAPMyListViewController

NSData *imageData;
@synthesize profilePicButton = _profilePicButton;
@synthesize profilePicture = _profilePicture;

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
        [_profilePicture setImage:croppedImage];
        CALayer *imageLayer = _profilePicture.layer;
        [imageLayer setCornerRadius:_profilePicture.frame.size.width/2];
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
    
    PFUser *user = [PFUser currentUser];
    
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


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    
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
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:self.textKey];
    cell.imageView.file = [object objectForKey:self.imageKey];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        HAPAddEventViewController *addEventViewController = [navigationController viewControllers][0];
        addEventViewController.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)addEventViewContollerDidAdd:(HAPAddEventViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadObjects];
}


@end
