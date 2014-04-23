//
//  HAPSelectEventTimeViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/19/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPSelectEventTimeViewController.h"

@interface HAPSelectEventTimeViewController ()

@end

@implementation HAPSelectEventTimeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *time;
        if (indexPath.row == 0)
            time = @"today";
        else if (indexPath.row == 1)
            time = @"tomorrow";
        else if (indexPath.row == 2)
            time = @"this week";
        else if (indexPath.row == 3)
            time = @"next week";
        else if (indexPath.row == 4)
            time = @"this month";
        else if (indexPath.row == 5)
            time = @"next month";
        else
            time = @"this year";
        
        [self.delegate selectEventTimeViewController:self DidSelectTime:time];
    }
}

@end
