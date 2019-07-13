//
//  DetailsPostViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "DetailsPostViewController.h"
@import Parse.PFImageView;

@import DateTools;
@interface DetailsPostViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation DetailsPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Image in the nav bar
    
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    [self changeImageButtonLike:_liked];
    NSMutableArray * arrayUsers = _myPost[@"peopleLiked"];
    _liked = ([arrayUsers containsObject:[[PFUser currentUser] username]]) ? YES : NO;
    [self changeImageButtonLike: _liked];
    _caption.text =_myPost[@"caption"];
    _image.file = _myPost[@"image"];
    PFUser * author = _myPost[@"author"];
    _username.text = [author username];
    NSDate * myDate = author.createdAt;
    _dateLabel.text = [[myDate shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
    _likeCount.text = [[NSString stringWithFormat:@"%@", _myPost[@"likeCount"]] stringByAppendingString:@" likes"];
    [self getProfilePicture:[author username]];
    
    // Do any additional setup after loading the view.
}


/**
 This is going to change the current photo for the one of the user, with the user name, this method is goint ot look for the profile pic
 
 
 -Parameters:
 -username: The user name of the user that has posted that photo
 */
-(void) getProfilePicture : (NSString *) username
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
                 
                 [_profilePicture setImage:thumbnailImageView.image];
                 _profilePicture.layer.cornerRadius = _profilePicture.frame.size.height/2;
                 [_profilePicture setClipsToBounds:YES];
                 [_profilePicture loadInBackground];
             }];
             
         }
         
     }];
}

/**
 changeImageButtonLike
 This method is going to change the photo in the button depending in the parameter
 
 
 -Parameters:
 -like: If the photo has been liked
 */
-(void) changeImageButtonLike : (BOOL) like
{
    if(like)
    {
        [_likeButton setImage:[UIImage imageNamed:@"favorited"] forState:(UIControlStateNormal)];
        
    }else
    {
        [_likeButton setImage:[UIImage imageNamed:@"favorite"] forState:(UIControlStateNormal)];
    }
    self.liked = like;
}


/**
 changeDatabaseLike
 This method is going to change the database  depending in the parameter
 
 
 -Parameters:
 -like: If the photo has been liked
 */
-(void) changeDatabaseLike : (BOOL) like
{
    if(like)
    {
        int value = [_myPost.likeCount intValue];
        _myPost.likeCount = [NSNumber numberWithInt: 1 + value];
        NSMutableArray * peopleLiked = _myPost.peopleLiked;
        [peopleLiked addObject:[[PFUser currentUser] username]];
        [_myPost setPeopleLiked:peopleLiked];
        
        [_myPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.delegateLike changeState];
              _likeCount.text = [[NSString stringWithFormat:@"%@", _myPost[@"likeCount"]] stringByAppendingString:@" likes"];
        }];
        
    }else
    {
        int value = [_myPost.likeCount intValue];
        _myPost.likeCount = [NSNumber numberWithInt: value - 1];
        NSMutableArray * peopleLiked = _myPost.peopleLiked;
        [peopleLiked removeObject:[[PFUser currentUser] username]];
        [_myPost setPeopleLiked:peopleLiked];
        [_myPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.delegateLike changeState];
              _likeCount.text = [[NSString stringWithFormat:@"%@", _myPost[@"likeCount"]] stringByAppendingString:@" likes"];
        }];
    }
}

- (IBAction)didLike:(UIButton *)sender {
    
    [self changeImageButtonLike:!self.liked];

    [self changeDatabaseLike:self.liked];


}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
