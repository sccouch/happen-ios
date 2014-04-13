//
//  HAPEventDetailViewController.m
//  happen-app
//
//  Created by Kalyn Nakano on 4/11/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPEventDetailViewController.h"
#import "HAPMeTooCell.h"

@interface HAPEventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (nonatomic) NSInteger meTooCount;
@property (nonatomic, strong) NSArray *meTooers;

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
    
    PFRelation *meToos = [self.selectedEvent relationForKey:@"meToos"];
    PFQuery *friendQuery = meToos.query;
    
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.meTooers = [NSMutableArray arrayWithArray:objects];
//            for (PFObject *object in self.meTooers) {
//                //NSLog(@"me tooer %@", object[@"firstName"]);
//            }
//            
            [self.meTooView reloadData];
            
        }
    }];
    
//    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//    _meTooView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_meTooView setDataSource:self];
    [_meTooView setDelegate:self];
    
    //[_meTooView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HAPMeTooCell"];
    
    [self.view addSubview:_meTooView];
	// Do any additional setup after loading the view.
    
    self.eventTitle.text = [NSString stringWithFormat:@"%@", self.selectedEvent[@"details"]];
    
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

    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
