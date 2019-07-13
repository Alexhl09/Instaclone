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
#import "ProfileViewController.h"
#import "InfiniteScrollActivityView.h"


@interface FeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate, didLike, didClickPhoto>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewInstaPost;
@property (strong, nonatomic) Post * selectedPost;
@property (strong, nonatomic) NSArray * posts;
@property (strong, nonatomic) PFUser * selectedUsername;
@property (assign, nonatomic) BOOL liked;
    

@end

@implementation FeedViewController
    bool isMoreDataLoading = false;
    InfiniteScrollActivityView* loadingMoreView;
UIRefreshControl *refreshControl = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _liked = NO;
    _posts = [NSArray new];
    _collectionViewInstaPost.delegate = self;
    _collectionViewInstaPost.dataSource = self;
    _collectionViewInstaPost.scrollEnabled = YES;
    
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.collectionViewInstaPost.contentSize.height, self.collectionViewInstaPost.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.collectionViewInstaPost addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.collectionViewInstaPost.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.collectionViewInstaPost.contentInset = insets;
    
    
    
    [self getLastTwentyPhotos];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    
    [refreshControl addTarget:self action:@selector(getLastTwentyPhotos) forControlEvents:UIControlEventValueChanged];
    
    [_collectionViewInstaPost addSubview:refreshControl];
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

/**
 This is going to activate a alert with all the option that the regular instagram app has
 */

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
    }else if([segue.identifier isEqualToString:@"profile"])
    {
        ProfileViewController * vc = [segue destinationViewController];
        vc.usernameProfile = _selectedUsername;
    }
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"cell";
    InstagramPostCollectionViewCell * myCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Post * myPost = _posts[indexPath.row];
    [myCell setPost:myPost];
    myCell.delegate = self;
    myCell.delegateProfile = self;
    
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



- (void)performSegue:(nonnull PFUser *)user {
    _selectedUsername = user;
    [self performSegueWithIdentifier:@"profile" sender:self];
}
    
-(void)loadMoreData
{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    query.skip = _posts.count;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.isMoreDataLoading = false;
            
            // Stop the loading indicator
            [loadingMoreView stopAnimating];
            _posts  = [posts arrayByAddingObject:posts];
            [_collectionViewInstaPost reloadData];
            // do something with the array of object returned by the call
        } else {
            
        }
        [refreshControl endRefreshing];
    }];
}

/**
 My infinite scrolling is not working, but this helps the user to get more photos
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        self.isMoreDataLoading = true;
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.collectionViewInstaPost.contentSize.height;
        
        int scrollOffsetThreshold = scrollViewContentHeight - (self.collectionViewInstaPost.bounds.size.height / 2);

 
        // When the user has scrolled past the threshold, start requesting
        NSLog(@"%i",scrollView.contentOffset.y);
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.collectionViewInstaPost.isDragging) {
            isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.collectionViewInstaPost.contentSize.height, self.collectionViewInstaPost.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
            // ... Code to load more results ...
        }
    }
}
    
    
    @end
