//
//  InstagramPostCollectionViewCell.m
//  Instaclone
//
//  Created by alexhl09 on 7/9/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//


#import "InstagramPostCollectionViewCell.h"
@import DateTools;
@implementation InstagramPostCollectionViewCell

/**
    Set post is goint to override the setter of post and change the properties of my cell
 
 - Parameters:
 - Post: This is an object of type Post that has inside the user and the data of the post
 
 -Returns:
    nil
 */
- (void)setPost:(Post *)post {
    _post = post;
    _photoImage.file = post[@"image"];
    self.liked = NO;
    NSMutableArray * arrayUsers = post[@"peopleLiked"];
    self.liked = ([arrayUsers containsObject:[[PFUser currentUser] username]]) ? YES : NO;
   
    [self changeImageButtonLike:self.liked];

   
    PFUser * author = post[@"author"];
    NSDate * myDate = author.createdAt;

    [_date setText:[[myDate shortTimeAgoSinceNow] stringByAppendingString:@" ago"]];
    [_author setText:author.username];
    
    [_caption setText:post[@"caption"]];

    _likeCount.text = [[NSString stringWithFormat:@"%@",post[@"likeCount"]] stringByAppendingString:@" likes"];
    

    [self getProfilePicture:author.username];
    [_photoImage loadInBackground];
 
}


/**
 Get Profile Picture
 
 This query is going to get the information of the user and display the profile image
 */
-(void) getProfilePicture : (NSString *) username
{
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:username];
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
    likePost is goign to notify the view controller that the cell has been liked
 */
- (IBAction)likePost:(UIButton *)sender {
    
    [self changeImageButtonLike:!self.liked];
    [self changeDatabaseLike:self.liked];
    
    
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
        [_buttonLikes setImage:[UIImage imageNamed:@"favorited"] forState:(UIControlStateNormal)];
        
    }else
    {
        [_buttonLikes setImage:[UIImage imageNamed:@"favorite"] forState:(UIControlStateNormal)];
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

        int value = [_post.likeCount intValue];
        _post.likeCount = [NSNumber numberWithInt: 1 + value];
        NSMutableArray * peopleLiked = _post.peopleLiked;
        [peopleLiked addObject:[[PFUser currentUser] username]];
        [_post setPeopleLiked:peopleLiked];

        [_post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.delegate changeState];
        }];
        
    }else
    {
        int value = [_post.likeCount intValue];
        _post.likeCount = [NSNumber numberWithInt: 1 - value];
        NSMutableArray * peopleLiked = _post.peopleLiked;
        [peopleLiked removeObject:[[PFUser currentUser] username]];
        [_post setPeopleLiked:peopleLiked];
        [_post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.delegate changeState];
        }];
    }
}
/**
 tapImage
 This method is to call the delegate's method that someone tap inside the photo of the user
 and is going to send thge info of that user depending on the cell
 */
- (IBAction)tapImage:(UIButton *)sender {
    PFUser * author = _post[@"author"];
    [self.delegateProfile performSegue:author];
}

    
@end
