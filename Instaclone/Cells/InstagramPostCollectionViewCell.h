//
//  InstagramPostCollectionViewCell.h
//  Instaclone
//
//  Created by alexhl09 on 7/9/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ViewControllers/Post.h"
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol didLike
-(void) changeState;
@end


@interface InstagramPostCollectionViewCell : UICollectionViewCell
//My properties of the cell that I want to display in the cell of the instagram Post
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonLikes;
@property (weak, nonatomic) IBOutlet PFImageView *photoImage;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) id <didLike> delegate;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) Post *post;
-(void) getProfilePicture : (NSString *) username;
@property  BOOL  liked;
-(void) changeImageButtonLike : (BOOL) like;
-(void) changeDatabaseLike : (BOOL) like;
@end

NS_ASSUME_NONNULL_END
