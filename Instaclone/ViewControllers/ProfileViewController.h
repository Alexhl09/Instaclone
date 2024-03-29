//
//  ProfileViewController.h
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "DetailProfileViewController.h"
#import "DetailsPostViewController.h"
#import "../Cells/MyPostCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
    @property (strong, nonatomic) PFUser * usernameProfile;
-(void) getMyPhotos;
@end

NS_ASSUME_NONNULL_END
