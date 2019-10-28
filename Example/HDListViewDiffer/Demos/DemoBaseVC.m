//
//  DemoBaseVC.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "DemoBaseVC.h"
#import "DemoBaseCell.h"
#import "DemoBaseModel.h"

@interface DemoBaseVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation DemoBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(@"DemoBaseCell") forCellWithReuseIdentifier:@"DemoBaseCell"];
    [self.view addSubview:_collectionView];
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DemoBaseCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoBaseCell" forIndexPath:indexPath];
    
    DemoBaseModel *m = self.dataArr[indexPath.item];
    cell.titleL.text = m.showText;
    cell.contentView.backgroundColor = m.bgColor;
    return  cell;//子类重写
}

@end
