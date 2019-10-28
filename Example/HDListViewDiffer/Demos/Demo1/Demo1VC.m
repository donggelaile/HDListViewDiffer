//
//  Demo1VC.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "Demo1VC.h"
#import "Demo1VCModel.h"
#import "NSArray+HDHelper.h"

@interface Demo1VC ()

@end

@implementation Demo1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addBtnClick];
    [self setNav];
    
    // Do any additional setup after loading the view.
}
- (void)setNav
{
    UIBarButtonItem *rightItem = [self barItemWithTitle:@"添加" clickAction:@selector(addBtnClick)];
    UIBarButtonItem *rightItem2 = [self barItemWithTitle:@"随机打乱" clickAction:@selector(shuffleBtnClick)];
    UIBarButtonItem *rightItem3 = [self barItemWithTitle:@"打乱+删除+增加" clickAction:@selector(complexClick)];
    UIBarButtonItem *rightItem4 = [self barItemWithTitle:@"更新id" clickAction:@selector(updateIdClick)];
    self.navigationItem.rightBarButtonItems = @[rightItem,rightItem2,rightItem3,rightItem4];
}
- (UIBarButtonItem*)barItemWithTitle:(NSString*)title clickAction:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn sizeToFit];
    return barItem;
}
- (void)updateIdClick
{
    //这里事实上使用了delete，insert组合 替代了 update, 实际效果上看基本与update一致
    //因此，实际中基本不会碰到update的元素，因为总可以用 delete，insert组合 来替代
    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newArrGenerateCode:^NSArray<id<HDListViewDifferProtocol>> * _Nonnull{
        //id变更代码放在此处，这样内部可以区分新旧模型id
        //因为变更后新旧数组可能内可能还是同一model,因此内部需要控制新数组生成函数 调用的时机，以此区分id
        Demo1VCModel *firstM = [self.dataArr firstObject];
        firstM.showText = @(arc4random()).stringValue;
        return self.dataArr;
    } calculateDiffFinishCb:nil sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
        self.dataArr = newArr;
    } animationFinishCallback:nil];
}

- (void)complexClick
{
    //此处不要对数据源做任何变更，即不要改变self.dataArr
    //可对其拷贝后变更生成新数据源
    NSArray *newArr = [[self.dataArr shuffle] randomDeleteCount:2];
    newArr = [self addNewItemWithCount:3 toArr:newArr];

    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
        self.dataArr = newArr; //数据源的变更必须放到这里
    } animationFinishCallback:nil];
    

}
- (void)shuffleBtnClick
{
    NSArray *newArr = [self.dataArr shuffle];
    
    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
        self.dataArr = newArr; //数据源的变更必须放到这里
    } animationFinishCallback:nil];

}
- (void)addBtnClick
{
    NSArray *newArr = [self addNewItemWithCount:10 toArr:self.dataArr];
    
    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
        self.dataArr = newArr; //数据源的变更必须放到这里
    } animationFinishCallback:nil];

}
- (NSArray*)addNewItemWithCount:(NSInteger)count toArr:(NSArray*)arr
{
    NSMutableArray *newArr = @[].mutableCopy;
    if (arr.count) {
        [newArr addObjectsFromArray:arr];
    }
    NSInteger pageCount = count;
    for (NSInteger i=arr.count; i<arr.count+pageCount; i++) {
        Demo1VCModel *m = [Demo1VCModel new];
        m.showText = @(i).stringValue;
        m.bgColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        [newArr addObject:m];
    }
    return newArr;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *newArr = [self.dataArr mutableCopy];
    [newArr removeObjectAtIndex:indexPath.row];

    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
        self.dataArr = newArr; //数据源的变更必须放到这里
    } animationFinishCallback:nil];
   
}
- (void)dealloc
{
    
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
