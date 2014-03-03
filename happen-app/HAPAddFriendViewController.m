//
//  HAPAddFriendViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 2/25/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "HAPAddFriendViewController.h"

@interface HAPAddFriendViewController ()
@property (nonatomic, unsafe_unretained) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *fetchedNumbers;
@end

@implementation HAPAddFriendViewController

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
    
    self.fetchedNumbers =  @[].mutableCopy;
    CFErrorRef error = NULL;
    
    // Check if user authorized access to address book
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized: {
            NSLog(@"Already authorized");
            self.addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            if (self.addressBook != nil) {
                NSLog(@"Succesful.");
                [self readFromAddressBook:self.addressBook];
                [self loadObjects];
            }
            //if (self.addressBook != NULL) CFRelease(self.addressBook);
            if (self.addressBook != NULL){
                CFRelease(self.addressBook);
                self.addressBook = NULL;
            }
            break;
        }
        case kABAuthorizationStatusDenied: {
            NSLog(@"Access denied to address book");
            break;
        }
        case kABAuthorizationStatusNotDetermined: {
            self.addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"Access was granted");
                    [self readFromAddressBook:self.addressBook];
                    [self loadObjects];
                }
                else NSLog(@"Access was not granted");
                if (self.addressBook != NULL) CFRelease(self.addressBook);
            });
            break;
        }
        case kABAuthorizationStatusRestricted: {
            NSLog(@"access restricted to address book");
            break;
        }
    }

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
    [self loadObjects];
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
    
    //PFQuery *query = [PFQuery queryWithClassName:@"User"];
    PFQuery *query = [PFUser query];
    if (self.fetchedNumbers == NULL) {
        NSLog(@"well fuck");
    }
    [query whereKey:@"phoneNumber" containedIn:self.fetchedNumbers];
    
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
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    NSString *firstName = [object objectForKey:self.textKey];
    NSString *lastName = [object objectForKey:@"lastName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    // And Profile picture
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    CALayer *imageLayer = cell.imageView.layer;
//    [imageLayer setCornerRadius:cell.imageView.frame.size.height/2];
//    [imageLayer setMasksToBounds:YES];
    
    cell.imageView.file = [object objectForKey:self.imageKey];
    
//    HAPAcceptFriendButton *acceptFriendRequestButton = [[HAPAcceptFriendButton alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
//    acceptFriendRequestButton.objectId = object.objectId;
//    [acceptFriendRequestButton setTitle:@"Accept" forState:UIControlStateNormal];
//    [acceptFriendRequestButton setBackgroundColor: [UIColor redColor]];
//    [cell addSubview:acceptFriendRequestButton];
//    [acceptFriendRequestButton addTarget:self
//                                  action:@selector(acceptFriendRequest:)
//                        forControlEvents:UIControlEventTouchUpInside];
    
    HAPRequestFriendButton *requestFriendButton = [[HAPRequestFriendButton alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
    requestFriendButton.user = (PFUser *)object;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

// Back button pressed
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Grabs phone numbers from address book after user gives permission
- (void) readFromAddressBook:(ABAddressBookRef)paramAddressBook{
    //NSLog(@"Method successfully called!");
    if(paramAddressBook == NULL) {
        NSLog(@"WHAT R U DOING");
    }
    NSMutableArray *allPhoneNumbers = @[].mutableCopy;
    NSArray *allContacts = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    for (id rec in allContacts){
        ABMultiValueRef mvr = ABRecordCopyValue((__bridge ABRecordRef)rec, kABPersonPhoneProperty);
        NSArray *currentNums = (__bridge NSArray*) ABMultiValueCopyArrayOfAllValues(mvr);
        [allPhoneNumbers addObjectsFromArray: currentNums];
    }
    
    //Clear dash & paren formatting, num only
    //NSMutableArray *allPhoneNumbersOnly = @[].mutableCopy;
    for (NSString *phoneNum in allPhoneNumbers) {
        NSString *phoneNumDecimalsOnly = [[phoneNum componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        //NSNumber *convertedNum = [NSNumber numberWithInt:[phoneNumDecimalsOnly intValue]];
        //[allPhoneNumbersOnly addObject: phoneNumDecimalsOnly];
        [self.fetchedNumbers addObject: phoneNumDecimalsOnly];
    }
    
    //For debugging: Log all phone numbers in contact book to console
    NSMutableString *exString = [[NSMutableString alloc]init];
    for (NSString *phoneNum in self.fetchedNumbers) {
        NSLog (@"%@", phoneNum);
        [exString appendFormat:@"\n%@",phoneNum];
    }
}


@end
