//
//  DSPDivideViewController.m
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/11/5.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#import "DSPDivideViewController.h"
#import "DanceSpiritDef.h"

//Cell
#import "DSPDivideCollectionViewCell.h"


@interface DSPDivideViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

@implementation DSPDivideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView {
    [self initCollectionView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemSpacing = 8.f;
    CGFloat lineSpacing = 0;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - itemSpacing * 3 - 16.f) / 4;
    CGFloat itemHeight = itemWidth * 1.25;
    
    [layout setSectionInset:UIEdgeInsetsMake(0, 8, 0, 8)];
    [layout setItemSize:CGSizeMake(itemWidth, itemHeight)];
    [layout setMinimumLineSpacing:lineSpacing];
    [layout setMinimumInteritemSpacing:itemSpacing];
    [_collectionView setCollectionViewLayout:layout];
    [_collectionView layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<NSString *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSArray arrayWithObjects:@"中国舞",@"现代舞",@"芭蕾舞",@"街舞",@"古典舞",@"肚皮舞",@"踢踏舞", nil];
    }
    return _dataSource;
}

#pragma mark UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DSPDivideCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DSPDivideCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.backgroundColor = [UIColor orangeColor];
    [cell.divideLabel setText:_dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
