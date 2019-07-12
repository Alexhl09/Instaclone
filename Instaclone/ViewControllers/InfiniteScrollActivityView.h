//
//  InfiniteScrollActivityView.h
//  Instaclone
//
//  Created by alexhl09 on 7/12/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface InfiniteScrollActivityView : UIView
    
    @property (class, nonatomic, readonly) CGFloat defaultHeight;
    
- (void)startAnimating;
- (void)stopAnimating;
    
    @end

NS_ASSUME_NONNULL_END
