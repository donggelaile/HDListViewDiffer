//
//  NSArray+HDHelper.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "NSArray+HDHelper.h"


@implementation NSArray (HDHelper)
- (NSArray *)shuffle
{
    // 转为可变数组
    NSMutableArray * tmp = self.mutableCopy;
    // 获取数组长度
    NSInteger count = tmp.count;
    // 开始循环
    while (count > 0) {
        // 获取随机角标
        NSInteger index = arc4random_uniform((int)(count - 1));
        // 获取角标对应的值
        id value = tmp[index];
        // 交换数组元素位置
        tmp[index] = tmp[count - 1];
        tmp[count - 1] = value;
        count--;
    }
    // 返回打乱顺序之后的数组
    return tmp.copy;
}
- (NSArray*)randomDeleteCount:(NSInteger)count
{
    if (count<=0) {
        return self;
    }
    NSMutableArray *tmp = self.mutableCopy;
    while (count--) {
        if (tmp.count<=0) {
            break;
        }
        [tmp removeObjectAtIndex:arc4random()%tmp.count];
    }
    return tmp;
}
@end
