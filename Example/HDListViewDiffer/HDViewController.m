//
//  HDViewController.m
//  HDListViewDiffer
//
//  Created by chenhaodong on 10/17/2019.
//  Copyright (c) 2019 chenhaodong. All rights reserved.
//

#import "HDViewController.h"

@interface HDViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArr = @[@"Demo1VC",@"DemoTableVC"];
    
    self.tableV = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.view addSubview:self.tableV];
    
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [NSClassFromString(self.dataArr[indexPath.row]) new];
//    vc.modalPresentationStyle = 0;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
