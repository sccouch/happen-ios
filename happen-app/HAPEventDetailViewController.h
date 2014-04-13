//
//  HAPEventDetailViewController.h
//  happen-app
//
//  Created by Kalyn Nakano on 4/11/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HAPEventDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) PFObject *selectedEvent;
@property (weak, nonatomic) IBOutlet UICollectionView *meTooView;
- (void)setEvent:(PFObject *)object;
@end
