//
//  ProfileViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "DetailProfileViewController.h"
#import "../Cells/MyPostCollectionViewCell.h"



@interface ProfileViewController () <EditedProfileDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberPost;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionMyProfile;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) NSArray * posts;

@end

@implementation ProfileViewController
UIRefreshControl *refreshControlProfile = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProfilePicture];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.height/2;
    _profileImage.clipsToBounds = YES;
    _collectionMyProfile.delegate = self;
    _collectionMyProfile.dataSource = self;
    //Image in the nav bar
    [_name setText:[[PFUser currentUser] username]];
    [_username setText:[[PFUser currentUser] username]];
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    // Do any additional setup after loading the view.
    [self getMyPhotos];
    refreshControlProfile = [[UIRefreshControl alloc] init];
    refreshControlProfile.tintColor = [UIColor grayColor];
    
    [refreshControlProfile addTarget:self action:@selector(getMyPhotos) forControlEvents:UIControlEventValueChanged];
    
    [_collectionMyProfile addSubview:refreshControlProfile];
}

/**
 Get Profile Picture
 
 This query is going to get the information of the user and display the profile image
 */
-(void) getProfilePicture
{
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:PFUser.currentUser.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error) {
            PFFileObject * file = object[@"ProfilePic"];
            //You found the user!
            [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
                
                 self.profileImage.image = thumbnailImageView.image;
                
            }];
           
        }
        
    }];
}


/**
 LogOut
 
 This function is going to take me
 
 */
- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        HomeViewController * vc  = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }];
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"details"])
    {
        DetailProfileViewController * vc = [segue destinationViewController];
        vc.delegate = self;
        vc.profileImage = _profileImage.image;
    }
}
/**
 Get all my photos from the database and put them inside the array
 
 
 -Parameters:
 nil
 
 */
-(void) getMyPhotos
{
    
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 100;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [_numberPost setText:[NSString stringWithFormat:@"%i", posts.count]];
            _posts = posts;
            [_collectionMyProfile reloadData];
            // do something with the array of object returned by the call
        } else {
        }
        [refreshControlProfile endRefreshing];
    }];
}
/**
 Change image
 This method is going to get the profile image again, now that the database has changed.
 
 This is part of the protocol that I created to pass the changes in the details view
 */
- (void)changeImage {
    [self getProfilePicture];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"cell";
    MyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setPost:_posts[indexPath.row]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _posts.count;
}

@end
