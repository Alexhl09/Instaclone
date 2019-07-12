//
//  DetailsPostViewController.h
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Cells/InstagramPostCollectionViewCell.h"
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NewPostDelegate

-(void) reloadData;
@end

@interface DetailsPostViewController : UIViewController
@property (nonatomic, weak) id<NewPostDelegate> delegate;
@property (nonatomic, strong) Post * myPost;
@property (nonatomic, weak) id <didLike> delegateLike;
@property BOOL liked;
-(void) getProfilePicture : (NSString *) username;

@end

NS_ASSUME_NONNULL_END
