//
//  FeedViewController.m
//  Instaclone
//
//  Created by alexhl09 on 7/8/19.
//  Copyright © 2019 alexhl09. All rights reserved.
//

#import "Post.h"
#import "FeedViewController.h"
#import "../Cells/InstagramPostCollectionViewCell.h"
#import "DetailsPostViewController.h"



@interface FeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, didLike>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewInstaPost;
@property (strong, nonatomic) Post * selectedPost;
@property (strong, nonatomic) NSArray * posts;
@property BOOL liked;
@end

@implementation FeedViewController
UIRefreshControl *refreshControl = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    _liked = NO;
    _posts = [NSArray new];
    _collectionViewInstaPost.delegate = self;
    _collectionViewInstaPost.dataSource = self;
    
    
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    [self getLastTwentyPhotos];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];

    [refreshControl addTarget:self action:@selector(getLastTwentyPhotos) forControlEvents:UIControlEventValueChanged];

    [_collectionViewInstaPost addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

-(void) getLastTwentyPhotos
{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            _posts = posts;
            [_collectionViewInstaPost reloadData];
            // do something with the array of object returned by the call
        } else {
        }
        [refreshControl endRefreshing];
    }];
}



- (IBAction)optionUser:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Options" message:@"What do you want to do?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"Report" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    
    }];
    UIAlertAction * mute = [UIAlertAction actionWithTitle:@"Mute" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * unfollow = [UIAlertAction actionWithTitle:@"Unfollow" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * share = [UIAlertAction actionWithTitle:@"Share" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:report];
    [alert addAction:mute];
    [alert addAction:unfollow];
    [alert addAction:share];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"details"])
    {
        DetailsPostViewController * vc = [segue destinationViewController];
        vc.myPost = _selectedPost;
        vc.liked = _liked;
        vc.delegateLike = self;
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"cell";
    InstagramPostCollectionViewCell * myCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Post * myPost = _posts[indexPath.row];
    [myCell setPost:myPost];
    myCell.delegate = self;
    
     return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPost = _posts[indexPath.row];
    [self performSegueWithIdentifier:@"details" sender:self];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _posts.count;
}


- (void)changeState {
    [self getLastTwentyPhotos];

}

@end
