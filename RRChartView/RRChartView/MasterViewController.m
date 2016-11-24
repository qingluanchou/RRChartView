//
//  MasterViewController.m
//  RRChartView
//
//  Created by 文亮 on 16/11/24.
//  Copyright © 2016年 liang. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "OneRunChartController.h"
#import "GtChartViewController.h"
#import "WYChartViewController.h"

@interface MasterViewController ()

@property (nonatomic,strong)NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.objects addObject:@"当月hs300变化曲线"];
    [self.objects addObject:@"当月hs300变化曲线2"];
    [self.objects addObject:@"操盘曲线"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *object = self.objects[indexPath.row];
    cell.textLabel.text = object ;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        OneRunChartController *oneVC = [[OneRunChartController alloc] init];
        [self.navigationController pushViewController:oneVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        WYChartViewController *twoVC = [[WYChartViewController alloc] init];
        [self.navigationController pushViewController:twoVC animated:YES];
    }
    else if (indexPath.row == 2)
    {
        GtChartViewController *twoVC = [[GtChartViewController alloc] init];
        [self.navigationController pushViewController:twoVC animated:YES];
    }
}

- (NSMutableArray *)objects
{
    if (_objects == nil) {
        _objects = [NSMutableArray array];
    }
    return _objects;

}


@end
