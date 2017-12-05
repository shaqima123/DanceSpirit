//
//  DSPMainViewController.m
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/10/10.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#import "DSPMainViewController.h"
#import "FDSlideBar.h"
#import "DSPMainPageCollectionViewCell.h"

@interface DSPMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) FDSlideBar *slideBar;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation DSPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0];;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setupSlideBar];
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

// Set up a slideBar and add it into view
- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    sliderBar.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0];
    
    // Init the titles of all the item
    sliderBar.itemsTitle = @[@"直播",@"最热",@"最新",@"推荐"];
    
    // Set some style to the slideBar
    sliderBar.itemColor = [UIColor whiteColor];
    sliderBar.itemSelectedColor = [UIColor orangeColor];
    sliderBar.sliderColor = [UIColor orangeColor];
    
    // Add the callback with the action that any item be selected
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
}


- (void)setupCollectionView {
    if(self.collectionView == nil) {
        CGRect frame = CGRectMake(0, 0,CGRectGetWidth(self.view.frame),CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.slideBar.frame));
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [self.view addSubview:self.collectionView];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor yellowColor];
        //    self.collectionView.bounces = NO;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        self.collectionView.center = CGPointMake(CGRectGetWidth(self.view.frame) * 0.5, CGRectGetHeight(self.view.frame) * 0.5 + CGRectGetMaxY(self.slideBar.frame) * 0.5);
        
        UINib *nib = [UINib nibWithNibName:@"DSPMainPageCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ContentCell"];
        
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSPMainPageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ContentCell" forIndexPath:indexPath];
    cell.text = self.slideBar.itemsTitle[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.slideBar.itemsTitle count];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];

    [self.slideBar selectSlideBarItemAtIndex:indexPath.row];
}

@end
