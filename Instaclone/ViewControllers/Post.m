//
//  Post.m
//  Instaclone
//
//  Created by alexhl09 on 7/9/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

@dynamic peopleLiked;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

/**
 ResizeImage is a method inside the Post class that is going to resize my image
 
 
 - Parameters:
 - image: This is the image that it is going to be resized
 - withSize: This is going to have a CGSize object with the size of the image desired.
 
 -Returns:
 image resized
 */
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
/**
 postUserImage post the method with the information that is provided
 
 
 - Parameters:
 - image: This is the image that it is going to be posted
 - withCaption: This is the caption that wants to be displayed with the iamge
 
 -Returns:
 completionBlock
 */
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    
    UIImage * resizedImage = [self resizeImage:image withSize:CGSizeMake(400, 400)];
    newPost.image = [self getPFFileFromImage: resizedImage];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
   
    newPost.commentCount = @(0);
    newPost.peopleLiked = [NSMutableArray new];
    [newPost saveInBackgroundWithBlock: completion];
}


/**
 this method get the PFFile from the image that is uploaded in the phone
 
 
 - Parameters:
 - image: This is the image that it is going to be converted to PFFile

 
 -Returns:
 image file
 */
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
