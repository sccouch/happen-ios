//
//  HAPEventDetailViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 4/11/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPEventDetailViewController.h"
#import "HAPFriendEventListViewController.h"
#import "HAPMeTooCell.h"

@interface HAPEventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeFrame;
@property (nonatomic) NSInteger meTooCount;
@property (nonatomic, strong) NSArray *meTooers;
@property (nonatomic) NSIndexPath *selectedIndex;

@end

@implementation HAPEventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.meTooers = [[NSArray alloc]init];

    self.meTooers = [self.selectedEvent objectForKey:@"MeToos"];

    [_meTooView setDataSource:self];
    [_meTooView setDelegate:self];
    
    [self.view addSubview:_meTooView];
	// Do any additional setup after loading the view.
    
    self.eventTitle.text = [NSString stringWithFormat:@"%@", self.selectedEvent[@"details"]];
    self.timeFrame.text = [NSString stringWithFormat:@"%@", self.selectedEvent[@"timeFrame"]];
    
    [super viewDidLoad];
    
    [self.meTooView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEvent:(PFObject *)object
{
    self.selectedEvent = object;
    NSLog(@"%@", self.selectedEvent[@"details"]);
}

#pragma mark - UICollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //NSLog(@"number of sections gests called, %lu", (unsigned long)[self.meTooers count]);
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   return [self.meTooers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    HAPMeTooCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HAPMeTooCell"
                                              forIndexPath:indexPath];
    
    if (!self.meTooers) {
        return cell;
    }
    
    else {
        PFObject *object = [self.meTooers objectAtIndex:indexPath.row];
        cell.profilePic.contentMode = UIViewContentModeScaleAspectFit;
        cell.profilePic.image = [UIImage imageNamed:@"placeholder.jpg"];
        PFFile *imageFile = [object objectForKey:@"profilePic"];
        CALayer *imageLayer = cell.profilePic.layer;
        [imageLayer setCornerRadius:cell.profilePic.frame.size.width/2];
        [imageLayer setMasksToBounds:YES];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            // Now that the data is fetched, update the cell's image property.
            cell.profilePic.image = [UIImage imageWithData:data];
        }];
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check that a new transition has been requested to the DetailViewController and prepares for it
    if ([segue.identifier isEqualToString:@"FriendList"]){
        
        // Capture the object (e.g. exam) the user has selected from the list
        //NSIndexPath *indexPath = [self.meTooView cellForItemAtIndexPath:self.selectedIndex];
        NSIndexPath *selectedIndexPath = [[self.meTooView indexPathsForSelectedItems] objectAtIndex:0];
        PFObject *object = [self.meTooers objectAtIndex:selectedIndexPath.row];
        
        HAPFriendEventListViewController *detailViewController = [segue destinationViewController];
        detailViewController.friend = object;
    }
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

@end
