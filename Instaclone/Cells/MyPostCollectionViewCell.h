//
//  MyPostCollectionViewCell.h
//  Instaclone
//
//  Created by alexhl09 on 7/11/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ViewControllers/Post.h"
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyPostCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (assign, nonatomic) BOOL liked;
- (void)setPost:(Post *)post;
@property (strong, nonatomic) Post * post;

@end

NS_ASSUME_NONNULL_END
