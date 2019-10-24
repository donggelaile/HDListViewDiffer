//
//  HDListViewDiffer.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/17.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "HDListViewDiffer.h"

@implementation HDCollectionViewUpdateItem
- (instancetype)initWithIndexPathBeforeUpdate:(NSIndexPath *)indexPathBeforeUpdate indexPathAfterUpdate:(NSIndexPath *)indexPathAfterUpdate
{
    self = [super init];
    _indexPathBeforeUpdate = indexPathBeforeUpdate;
    _indexPathAfterUpdate = indexPathAfterUpdate;
    return self;
}
@end

@implementation HDListViewDiffer

static NSString * HDGetDataIdentifier(id<HDListViewDifferProtocol> data)
{
    if ([data respondsToSelector:@selector(hdDiffIdentifier)]) {
        return [data hdDiffIdentifier];
    }else{
        return [NSString stringWithFormat:@"%p",data];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isExistEqualItemInOldOrNewArr = YES;
    }
    return self;
}

- (void)setSection:(NSInteger)section oldData:(NSArray<id<HDListViewDifferProtocol>> *)oldArr newData:(NSArray<id<HDListViewDifferProtocol>> *)newArr finishCalback:(void (^)(void))finishcb
{
    _deletItems = @[];
    _insertItems = @[];
    _updateItems = @[];
    _moveItems = @[];
    
    _isExistEqualItemInOldOrNewArr = NO;
    //1、构建index 映射
    NSMutableDictionary *oldIndexDic = @{}.mutableCopy;
    [oldArr enumerateObjectsUsingBlock:^(id<HDListViewDifferProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (oldIndexDic[HDGetDataIdentifier(obj)]) {
            //存在相同元素
            _isExistEqualItemInOldOrNewArr = YES;
            *stop = YES;
        }
        oldIndexDic[HDGetDataIdentifier(obj)] = @(idx);
    }];
    NSMutableDictionary *newIndexDic = @{}.mutableCopy;
    [newArr enumerateObjectsUsingBlock:^(id<HDListViewDifferProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (newIndexDic[HDGetDataIdentifier(obj)]) {
            //存在相同元素
            _isExistEqualItemInOldOrNewArr = YES;
            *stop = YES;
        }
        newIndexDic[HDGetDataIdentifier(obj)] = @(idx);
    }];
    
    if (_isExistEqualItemInOldOrNewArr) {
        //存在相同元素直接返回，后续会直接调用reloadData。因为后面的算法不支持存在相同元素的情况...
        if (finishcb) {
            finishcb();
        }
        return;
    }
    
    //2、查找需要 删除 的数据
    NSMutableArray *deleteIndexPaths = @[].mutableCopy;
    [oldArr enumerateObjectsUsingBlock:^(id<HDListViewDifferProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *oldIndexP = [NSIndexPath indexPathForItem:idx inSection:section];
        NSNumber *newIndex = newIndexDic[HDGetDataIdentifier(obj)];
        if (!newIndex) {
            [deleteIndexPaths addObject:oldIndexP];
        }
    }];

    
    //3、查找需要插入的数据
    NSMutableArray *insertIndexPaths = @[].mutableCopy;
    [newArr enumerateObjectsUsingBlock:^(id<HDListViewDifferProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!oldIndexDic[HDGetDataIdentifier(obj)]) {
            [insertIndexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
        }
    }];
    
    //4、查找需要 更新、移动的数据
    NSMutableArray *moveItems = @[].mutableCopy;
    NSMutableArray *updateIndexPaths = @[].mutableCopy;
    
    [oldArr enumerateObjectsUsingBlock:^(id<HDListViewDifferProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //计算idx在经过 删除、插入后 新的位置
        //如果计算后的新位置与新数组位置一致，则该项不需要进行move操作
        NSInteger offsetIndex = idx - [self getDeleteOffset:deleteIndexPaths currentIdx:idx] + [self getInsertOffset:insertIndexPaths currentIdx:idx];
                
        NSIndexPath *oldIndexP = [NSIndexPath indexPathForItem:idx inSection:section];
        NSIndexPath *newIndexP = nil;
        NSNumber *newIndex = newIndexDic[HDGetDataIdentifier(obj)];
        if (!newIndex) {
            //需要删除的，前面已经计算了
        }
        else if ([newIndex integerValue] != idx && [newIndex integerValue] != offsetIndex){
            
            newIndexP = [NSIndexPath indexPathForItem:[newIndex integerValue] inSection:section];
            HDCollectionViewUpdateItem *item = [[HDCollectionViewUpdateItem alloc] initWithIndexPathBeforeUpdate:oldIndexP indexPathAfterUpdate:newIndexP];
            [moveItems addObject:item];
            
        }else{
            id<HDListViewDifferProtocol> newObj = newArr[[newIndex integerValue]];
            if (![HDGetDataIdentifier(obj) isEqualToString:HDGetDataIdentifier(newObj)]) {
                [updateIndexPaths addObject:oldIndexP];
            }
        }
    }];
    
    _deletItems = deleteIndexPaths;
    _insertItems = insertIndexPaths;
    _updateItems = updateIndexPaths;
    _moveItems = moveItems;
    if (finishcb) {
        finishcb();
    }
#ifdef DEBUG
NSLog(@"");
NSLog(@"\n****************************只会在DEBUG模式下打印**************************** \n删除%@项\n插入%@项\n更新%@项\n移动%@项\n",@(_deletItems.count),@(_insertItems.count),@(_updateItems.count),@(_moveItems.count));
#endif
}


- (NSInteger)getDeleteOffset:(NSArray<NSIndexPath*>*)deleteIndexPaths currentIdx:(NSInteger)curIndex
{
    NSInteger start = 0, end = deleteIndexPaths.count-1;
    while (start<=end) {
        NSInteger mid = (start+end)/2;
        NSInteger midIndex = [deleteIndexPaths[mid] item];
        if (curIndex>midIndex) {
            if (start == mid) {
                start ++;
            }else{
                start = mid;
            }
        }else if (curIndex<midIndex){
            if (end == mid) {
                end --;
            }else{
                end = mid;
            }
        }else{
            break;
        }
    }
    
    return start;
    
}

- (NSInteger)getInsertOffset:(NSArray<NSIndexPath*>*)insertIndexPaths currentIdx:(NSInteger)curIndex
{
    NSInteger start = 0, end = insertIndexPaths.count-1;
    while (start<=end) {
        NSInteger mid = (start+end)/2;
        NSInteger midIndex = [insertIndexPaths[mid] item];
        if (curIndex>midIndex) {
            if (start == mid) {
                start ++;
            }else{
                start = mid;
            }
        }else if (curIndex<midIndex){
            if (end == mid) {
                end --;
            }else{
                end = mid;
            }
        }else{
            start++;
            break;
        }
    }
    
    return start;
    
}
@end
