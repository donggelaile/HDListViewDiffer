//
//  DemoTableVC.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/22.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "DemoTableVC.h"
#import "DemoTableVCCell.h"
#import "DemoTableCellModel.h"
#import "NSArray+HDHelper.h"
#import "UITableView+HDDiffReload.h"

@interface DemoTableVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation DemoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addBtnClick];
    // Do any additional setup after loading the view.
}
- (void)setUI
{
    self.tableV = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerClass:[DemoTableVCCell class] forCellReuseIdentifier:@"DemoTableVCCell"];
    [self.view addSubview:self.tableV];
    
    [self setNav];
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

    [self.tableV hd_reloadWithSection:0 oldData:self.dataArr newData:newArr rowAnimation:UITableViewRowAnimationFade sourceDataChangeCode:^{
        self.dataArr = newArr;//数据源的变更必须放到这里
    } dataChangeFinishCallback:^{

    }];
}
- (void)shuffleBtnClick
{
    NSArray *newArr = [self.dataArr shuffle];
    [self.tableV hd_reloadWithSection:0 oldData:self.dataArr newData:newArr rowAnimation:UITableViewRowAnimationFade sourceDataChangeCode:^{
        self.dataArr = newArr;//数据源的变更必须放到这里
    } dataChangeFinishCallback:^{

    }];
}
- (void)addBtnClick
{
    NSArray *newArr = [self addNewItemWithCount:3 toArr:self.dataArr];
    [self.tableV hd_reloadWithSection:0 oldData:self.dataArr newData:newArr rowAnimation:UITableViewRowAnimationFade sourceDataChangeCode:^{
        self.dataArr = newArr;//数据源的变更必须放到这里
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
        DemoTableCellModel *m = [DemoTableCellModel new];
        m.bgColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        m.showText = @(i).stringValue;
        [newArr addObject:m];
    }
    return newArr;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoTableCellModel *model = self.dataArr[indexPath.row];
    DemoTableVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoTableVCCell"];
    cell.textLabel.text = model.showText;
    cell.contentView.backgroundColor = model.bgColor;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *newArr = self.dataArr.mutableCopy;
    [newArr removeObjectAtIndex:indexPath.row];
    
    [tableView hd_reloadWithSection:indexPath.section oldData:self.dataArr newData:newArr rowAnimation:UITableViewRowAnimationAutomatic sourceDataChangeCode:^{
        self.dataArr = newArr;
    } dataChangeFinishCallback:^{
        
    }];
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
