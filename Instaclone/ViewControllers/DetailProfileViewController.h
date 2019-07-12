//
//  DetailProfileViewController.h
//  Instaclone
//
//  Created by alexhl09 on 7/10/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
  Create new protocol to change the profile picture with the one selected in the details Profile View controller
 
 */
@protocol EditedProfileDelegate

-(void) changeImage;

@end

@interface DetailProfileViewController : UIViewController
@property (nonatomic, weak) id<EditedProfileDelegate> delegate;
@property (nonatomic, weak) UIImage * profileImage;
@end

NS_ASSUME_NONNULL_END
