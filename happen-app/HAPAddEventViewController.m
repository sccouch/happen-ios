//
//  HAPAddEventViewController.m
//  happen-app
//
//  Created by Jack Okerman on 2/13/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPAddEventViewController.h"

@interface HAPAddEventViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;

@end

@implementation HAPAddEventViewController

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"details"] = self.detailsTextView.text;
    event[@"timeFrame"] = self.eventTimeLabel.text;
    [event setObject:[PFUser currentUser] forKey:@"creator"];
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate addEventViewContollerDidAdd:self];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 180;
    }
    else return 50;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectEventTime"]) {
        HAPSelectEventTimeViewController *selectEventTimeViewController = segue.destinationViewController;
        selectEventTimeViewController.delegate = self;
    }
}

- (void)selectEventTimeViewController: (HAPSelectEventTimeViewController *)controller DidSelectTime:(NSString *)time {
    [self.navigationController popViewControllerAnimated:YES];
    self.eventTimeLabel.text = time;
}

@end
