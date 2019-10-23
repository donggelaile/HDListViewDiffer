//
//  DemoBaseCell.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "DemoBaseCell.h"

@implementation DemoBaseCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        
    }
    self.titleL = [UILabel new];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleL];
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleL.frame = self.bounds;
    self.contentView.layer.cornerRadius = self.contentView.frame.size.height/2;
}
@end
