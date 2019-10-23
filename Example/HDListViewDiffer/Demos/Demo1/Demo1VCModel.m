//
//  Demo1VCModel.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "Demo1VCModel.h"

@implementation Demo1VCModel
- (NSString *)hdDiffIdentifier
{
    return @([self hash]).stringValue;
}
@end
