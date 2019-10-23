//
//  DemoBaseVC.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+HDDiffReload.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemoBaseVC : UIViewController<UICollectionViewDataSource>
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<id<HDListViewDifferProtocol>> *dataArr;
@end

NS_ASSUME_NONNULL_END
