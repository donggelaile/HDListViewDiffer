//
//  DemoTableCellModel.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/22.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
// model 也可以不实现 - (NSString*)hdDiffIdentifier;
// 此时会用model的内存地址做为 唯一id ,因此保证增删时都是新创建的model即可
NS_ASSUME_NONNULL_BEGIN

@interface DemoTableCellModel : NSObject
@property (nonatomic, strong) NSString *showText;
@property (nonatomic, strong) UIColor *bgColor;
@end

NS_ASSUME_NONNULL_END
