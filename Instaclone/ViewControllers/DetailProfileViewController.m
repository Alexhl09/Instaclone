//
//  DetailProfileViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "DetailProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
@interface DetailProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITableView *tableViewInfoUser;
@property (strong, nonatomic) NSArray * infoUser;
@end

@implementation DetailProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewInfoUser.delegate = self;
    _tableViewInfoUser.dataSource = self;
    _image.layer.cornerRadius = _image.frame.size.height / 2;
    _image.clipsToBounds = YES;
    _image.image = _profileImage;
    _infoUser = @[@"Name", @"Username", @"Bio", @"Email", @"Phone", @"Gender"];

    
    //Image in the nav bar
    
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    // Do any additional setup after loading the view.
}
- (IBAction)changePhoto:(UIButton *)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText: _infoUser[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoUser.count;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [_image setImage: originalImage];
    
    NSData *imageData = UIImagePNGRepresentation([Post resizeImage:originalImage withSize:CGSizeMake(200, 200)]);
    
    [PFUser currentUser][@"ProfilePic"] = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.delegate changeImage];
        }else
        {
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    // Dismiss UIImagePickerController to go back to your original view controller
    
}


@end
