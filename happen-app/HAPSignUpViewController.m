//
//  HAPSignUpViewController.m
//  happen-app
//
//  Created by Jack Okerman on 1/30/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HAPSignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@end

@implementation HAPSignUpViewController

NSData *imageData;
@synthesize profilePicButton = _profilePicButton;
@synthesize profilePic = _profilePic;

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
    [self setProfilePicButton:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.firstNameField becomeFirstResponder];
    
    CALayer *imageLayer = _profilePic.layer;
    [imageLayer setCornerRadius:_profilePic.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [_profilePic setImage:croppedImage];
        CALayer *imageLayer = _profilePic.layer;
        [imageLayer setCornerRadius:_profilePic.frame.size.width/2];
        [imageLayer setMasksToBounds:YES];
        imageData = UIImagePNGRepresentation(croppedImage);
        
        //[self.profilePicButton setTitle: @"Edit photo" forState:UIControlStateHighlighted];
    }
    
}

- (IBAction)joinButtonPressed:(id)sender {
    if ([self requiredFieldsBlank]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Required fields must not be left blank." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = TAG_BLANK;
        [alert show];
    }
    else if (![self passwordsMatch]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The passwords you entered do not match." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = TAG_PASSWORDS;
        [alert show];
    }
    else {
        [self signUpUser:[self getUserInfo]];
    }
}

- (BOOL)requiredFieldsBlank {
    return ([self.firstNameField.text isEqualToString:@""]
            || [self.lastNameField.text isEqualToString:@""]
            || [self.usernameField.text isEqualToString:@""]
            || [self.passwordField.text isEqualToString:@""]
            || [self.confirmPasswordField.text isEqualToString:@""]);
}

- (BOOL)passwordsMatch {
    return ([self.passwordField.text isEqualToString:self.confirmPasswordField.text]);
}

- (NSMutableDictionary *)getUserInfo {
    
    PFFile *imageFile = [PFFile fileWithName:@"profile.png" data:imageData];
    [imageFile saveInBackground];

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:self.firstNameField.text forKey:@"firstName"];
    [userInfo setObject:self.lastNameField.text forKey:@"lastName"];
    [userInfo setObject:self.usernameField.text forKey:@"username"];
    [userInfo setObject:self.passwordField.text forKey:@"password"];
    [userInfo setObject:self.confirmPasswordField.text forKey:@"confirmPassword"];
    [userInfo setObject:imageFile forKey:@"profilePic"];
    return userInfo;
}

- (void)signUpUser:(NSMutableDictionary*)userInfo {
    PFUser *user = [PFUser user];
    user.username = [userInfo objectForKey:@"username"];
    user.password = [userInfo objectForKey:@"password"];
    
    
    user[@"firstName"] = [userInfo objectForKey:@"firstName"];
    user[@"lastName"] = [userInfo objectForKey:@"lastName"];
    user[@"profilePic"] = [userInfo objectForKey:@"profilePic"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your user account was created successfully." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            alert.tag = TAG_SUCCESS;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error creating you user account" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            alert.tag = TAG_ERROR;
            [alert show];
        }
    }];
}

- (void)clearUserInfo {
    self.firstNameField.text = @"";
    self.lastNameField.text = @"";
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.confirmPasswordField.text = @"";
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_BLANK) {}
    else if (alertView.tag == TAG_PASSWORDS) {
        self.passwordField.text = @"";
        self.confirmPasswordField.text = @"";
        [self.passwordField becomeFirstResponder];
        
    }
    else if (alertView.tag == TAG_SUCCESS) {
        [self userDidSignUp];
    }
    else if (alertView.tag == TAG_ERROR) {
        [self clearUserInfo];
        [self.firstNameField becomeFirstResponder];
    }
}

- (void)userDidSignUp {
    [self.delegate signUpViewControllerDidSignUp:self];
}

@end
