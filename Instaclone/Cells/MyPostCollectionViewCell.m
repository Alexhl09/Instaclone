//
//  MyPostCollectionViewCell.m
//  Instaclone
//
//  Created by alexhl09 on 7/11/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "MyPostCollectionViewCell.h"

@implementation MyPostCollectionViewCell
- (void)setPost:(Post *)post {
    _post = post;
  

    PFFileObject * file = post[@"image"];
    //You found the user!

    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *thumbnailImage = [UIImage imageWithData:imageData];
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
        
        self.image.image = thumbnailImageView.image;
        
    }];
    self.liked = NO;
    NSMutableArray * arrayUsers = post[@"peopleLiked"];
    self.liked = ([arrayUsers containsObject:[[PFUser currentUser] username]]) ? YES : NO;
}
@end
