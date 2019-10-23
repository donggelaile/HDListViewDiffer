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
    self.navigationItem.rightBarButtonItems = @[rightItem,rightItem2,rightItem3];
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
- (void)complexClick
{
    //此处不要对数据源做任何变更，即不要改变self.dataArr
    //可对其拷贝后变更生成新数据源
    NSArray *newArr = [[self.dataArr shuffle] randomDeleteCount:2];
    newArr = [self addNewItemWithCount:3 toArr:newArr];

    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^{
        self.dataArr = newArr;//数据源的变更必须放到这里
    } dataChangeFinishCallback:^{

    }];
}
- (void)shuffleBtnClick
{
    NSArray *newArr = [self.dataArr shuffle];
    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^{
        self.dataArr = newArr;
    } dataChangeFinishCallback:^{
        
    }];
}
- (void)addBtnClick
{
    NSArray *newArr = [self addNewItemWithCount:10 toArr:self.dataArr];
    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^{
        self.dataArr = newArr;
    } dataChangeFinishCallback:^{
        
    }];

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
        [newArr addObject:m];
    }
    return newArr;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *newArr = [self.dataArr mutableCopy];
    [newArr removeObjectAtIndex:indexPath.row];

    [self.collectionView hd_reloadWithSection:0 oldData:self.dataArr newData:newArr sourceDataChangeCode:^{
        self.dataArr = newArr;
    } dataChangeFinishCallback:^{
        
    }];
   
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
