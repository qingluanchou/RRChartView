//
//  GtChartViewController.m
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2016年 renrencaopan. All rights reserved.

#import "GtChartViewController.h"
#import "RRGridChart.h"
#import "RRStickChartData.h"
#import "RRStickChart.h"
#import "RRMAStickChart.h"
#import "RRLineData.h"
#import "RRTitledLine.h"
#import "ProductChart.h"
#import "CustomLabel.h"
#import "Masonry.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
//iphone4
#define iphone4 ([UIScreen mainScreen].bounds.size.height <= 480)
@interface GtChartViewController ()<CCSChartDelegate>
{
    CGFloat h ;
}

@property (nonatomic,strong)RRMAStickChart *stickChart;

@property (nonatomic,strong)NSArray *productChartList;

//日期
@property (nonatomic,weak)UILabel *timeLabel;

//hs300
@property (nonatomic,weak)UILabel *CSI300Label;

//当日净值
@property (nonatomic,weak)UILabel *dayNetWorthLabel;

//仓位
@property (nonatomic,weak)UILabel *positionLabel;

@property (nonatomic,weak)UILabel *currentPositionLabel;

@property (nonatomic,weak)UILabel *refreshTimeLabel;

@property (nonatomic,strong)NSDateFormatter *format;

@end

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@implementation GtChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"操盘曲线";
    h = 150;
    
    [self setHeaderView];
    
    RRMAStickChart *stickchart = [[RRMAStickChart alloc] init];
    [self.view addSubview:stickchart];
    WEAKSELF(weakSelf)
    [stickchart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(screenW));
        make.top.equalTo(weakSelf.view).offset(h);
        make.height.mas_equalTo(@(screenW * 0.5));
        make.left.equalTo(weakSelf.view);
    }];
    self.stickChart = stickchart;
    
    CustomLabel *oneLabel = [CustomLabel setCustomLabelText:@"当日净值(元)" font:8 textColor:[UIColor colorWithRed:43/255.0 green:154/255.0 blue:200/255.0 alpha:1.0]];
    [self.view addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.stickChart.mas_right).offset(-30);
        make.bottom.equalTo(weakSelf.stickChart.mas_top);
    }];
    
    CustomLabel *twoLabel = [CustomLabel setCustomLabelText:@"仓位" font:8 textColor:[UIColor colorWithRed:43/255.0 green:154/255.0 blue:200/255.0 alpha:1.0]];
    [self.view addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.stickChart.mas_left).offset(30);
        make.bottom.equalTo(weakSelf.stickChart.mas_top);
    }];
    [self setFooterView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dataList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *data = [dict objectForKey:@"data"];
    NSArray *productList = [ProductChart getProductChartList:data];
    [self dealWithListData:productList];
}

#pragma mark - **************** 创建头部视图
- (void)setHeaderView
{
    UILabel *timeLabelTitle = [[UILabel alloc] init];
    timeLabelTitle.text = @"日期:";
    timeLabelTitle.font = [UIFont systemFontOfSize:11];
    timeLabelTitle.textColor = [UIColor grayColor];
    [self.view addSubview:timeLabelTitle];
    [timeLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(120);
    make.left.equalTo(self.view).offset(15);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"12-14";
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabelTitle.mas_right);
        make.centerY.equalTo(timeLabelTitle);
    }];
    self.timeLabel = timeLabel;
    
    UILabel *CSI300LabelTitle = [[UILabel alloc] init];
    CSI300LabelTitle.text = @"沪深300:";
    CSI300LabelTitle.font = [UIFont systemFontOfSize:11];
    CSI300LabelTitle.textColor = [UIColor grayColor];
    [self.view addSubview:CSI300LabelTitle];
    [CSI300LabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(5);
        make.centerY.equalTo(timeLabelTitle);
    }];
    
    UILabel *CSI300Label = [[UILabel alloc] init];
    CSI300Label.text = @"3722.10";
    CSI300Label.font = [UIFont systemFontOfSize:12];
    CSI300Label.textColor = [UIColor blackColor];
    [self.view addSubview:CSI300Label];
    [CSI300Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(CSI300LabelTitle.mas_right);
        make.centerY.equalTo(timeLabelTitle);
    }];
    self.CSI300Label = CSI300Label;
    
    UILabel *dayNetWorthLabelTitle = [[UILabel alloc] init];
    dayNetWorthLabelTitle.text = @"当日净值:";
    dayNetWorthLabelTitle.font = [UIFont systemFontOfSize:11];
    dayNetWorthLabelTitle.textColor = [UIColor grayColor];
    [self.view addSubview:dayNetWorthLabelTitle];
    [dayNetWorthLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(CSI300Label.mas_right).offset(5);
        make.centerY.equalTo(timeLabelTitle);
    }];
    
    UILabel *dayNetWorthLabel = [[UILabel alloc] init];
    dayNetWorthLabel.text = @"0.00";
    dayNetWorthLabel.textColor = [UIColor colorWithRed:117/255.0 green:200/255.0 blue:26/255.0 alpha:1.0];
    dayNetWorthLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:dayNetWorthLabel];
    [dayNetWorthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayNetWorthLabelTitle.mas_right);
        make.centerY.equalTo(timeLabelTitle);
    }];
    self.dayNetWorthLabel = dayNetWorthLabel;
    
    UILabel *positionLabelTitle = [[UILabel alloc] init];
    positionLabelTitle.text = @"仓位:";
    positionLabelTitle.font = [UIFont systemFontOfSize:11];
    positionLabelTitle.textColor = [UIColor grayColor];
    [self.view addSubview:positionLabelTitle];
    [positionLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayNetWorthLabel.mas_right).offset(5);
        make.centerY.equalTo(timeLabelTitle);
    }];
    
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"0%";
    positionLabel.font = [UIFont systemFontOfSize:12];
    positionLabel.textColor = [UIColor blackColor];
    [self.view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(positionLabelTitle.mas_right);
        make.centerY.equalTo(timeLabelTitle);
    }];
    self.positionLabel = positionLabel;
    
}

#pragma mark - **************** 展示动态曲线数据
- (void)setHeaderData:(ProductChart *)chart
{
    self.format.dateFormat = @"MM-dd";
    long long  time = [chart.tradingDate longLongValue] /1000;
    NSDate * todate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr =  [self.format stringFromDate:todate];
    self.timeLabel.text = timeStr;
    self.CSI300Label.text = [NSString stringWithFormat:@"%.02f",chart.hs300];
    self.dayNetWorthLabel.text = [NSString stringWithFormat:@"%.02f",chart.unitValue];
    self.positionLabel.text = [NSString stringWithFormat:@"%.02f%%",chart.stockPercentage];
    
}


#pragma mark - **************** 处理数据，创建图标
- (void)dealWithListData:(NSArray *)contentList
{
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:contentList.count];
    [contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        ProductChart *pc = (ProductChart *)obj;
        if (pc.hs300 && pc.unitValue)
        {
            [list addObject:pc];
        }
    }];
    
    self.productChartList = list.copy;
    NSMutableArray *stickData = [[NSMutableArray alloc] init];
    NSMutableArray *linesdata = [[NSMutableArray alloc] init];
    NSMutableArray *currentLinedata = [[NSMutableArray alloc] initWithCapacity:list.count];
    NSMutableArray *hs300Linedata = [[NSMutableArray alloc] initWithCapacity:list.count];
    self.format.dateFormat = @"MM/dd";
    __block double toplevel = 1.02 ;
    __block double bottomlevel = 0.96;
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      ProductChart *chart = (ProductChart *)obj;
      long long time = [chart.tradingDate longLongValue] /1000;
      NSDate * todate = [NSDate dateWithTimeIntervalSince1970:time];
      NSString *timeStr =  [self.format stringFromDate:todate];
      [currentLinedata addObject:[[RRLineData alloc] initWithValue:chart.unitValue date:timeStr]];
      [hs300Linedata addObject:[[RRLineData alloc] initWithValue:chart.hs300Rate date:timeStr]];
      [stickData addObject:[[RRStickChartData alloc] initWithHigh:chart.stockPercentage low:0 date:timeStr]];
      toplevel = (toplevel < chart.unitValue) ? chart.unitValue : toplevel;
      toplevel = (toplevel < chart.hs300Rate) ? chart.hs300Rate : toplevel;
      bottomlevel = (bottomlevel > chart.unitValue) ? chart.unitValue : bottomlevel;
      bottomlevel = (bottomlevel > chart.hs300Rate) ? chart.hs300Rate : bottomlevel;
    }];
    
    //红色，当日净值
    RRTitledLine *currentRateLine = [[RRTitledLine alloc] init];
    currentRateLine.data = currentLinedata;
    currentRateLine.color = [UIColor colorWithRed:255/255.0 green:71/255.0 blue:71/255.0 alpha:1.0];
    currentRateLine.title = @"currentRate";

    RRTitledLine *hs300RateLine = [[RRTitledLine alloc] init];
    hs300RateLine.data = hs300Linedata;
    hs300RateLine.color = [UIColor colorWithRed:89/255.0 green:171/255.0 blue:205/255.0 alpha:1.0];
    hs300RateLine.title =  @"hs300rate";
    
    [linesdata addObject:currentRateLine];
    [linesdata addObject:hs300RateLine];
    NSInteger count = list.count;
    //设置stickData
    self.stickChart.stickData = stickData;
    self.stickChart.linesData = linesdata;
    self.stickChart.maxValue = 100;
    self.stickChart.minValue = 0;
    self.stickChart.latitudeNum = 5;
    self.stickChart.zAxisNum = 7;
    if (count < 10){
        self.stickChart.longitudeNum = count;
    }
    else
    {
        self.stickChart.longitudeNum = 8;
    }
    self.stickChart.displayCrossYOnTouch = NO;
    self.stickChart.stickFillColor = [UIColor colorWithRed:220/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    self.stickChart.backgroundColor = [UIColor whiteColor];
    self.stickChart.chartDelegate = self;
    self.stickChart.maxValue1 = toplevel;
    self.stickChart.minValue1 = bottomlevel;
    self.stickChart.selectedStickIndex = count;
    if (count){
        [self setHeaderData:self.productChartList[count -1]];
    }
    self.stickChart.virtualSticksNum = 10;
    self.stickChart.maxSticksNum = count;
    self.stickChart.orginMaxSticksNum = count;
}

#pragma mark - **************** 代理方法，获取每一点的数据
- (void)CCSChartBeTouchedOn:(CGPoint)point indexAt:(CC_UINT_TYPE)index{
    if (index < self.productChartList.count){
        [self setHeaderData:self.productChartList[index]];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)setFooterView
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    WEAKSELF(weakSelf);
   
    if (iphone4)
    {
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.stickChart.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(180, 15));
        }];

    }
    else
    {
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.stickChart.mas_bottom).offset(0.2 * h);
            make.size.mas_equalTo(CGSizeMake(180, 15));
        }];
    }

    
    
    UIImageView *worthIcon = [[UIImageView alloc] init];
    worthIcon.image = [UIImage imageNamed:@"redCircle"];
    [footerView addSubview:worthIcon];
    [worthIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView);
        make.top.equalTo(footerView);
    }];
    
    UILabel *dayNetWorthLabel = [[UILabel alloc] init];
    dayNetWorthLabel.text = @"当日净值";
    dayNetWorthLabel.font = [UIFont systemFontOfSize:12];
    dayNetWorthLabel.textColor = [UIColor grayColor];
    [footerView addSubview:dayNetWorthLabel];
    [dayNetWorthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(worthIcon.mas_right);
        make.centerY.equalTo(worthIcon);
    }];
    
    UIImageView *CSI300Icon = [[UIImageView alloc] init];
    CSI300Icon.image = [UIImage imageNamed:@"blueCircle"];
    [footerView addSubview:CSI300Icon];
    [CSI300Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayNetWorthLabel.mas_right).offset(15);
        make.centerY.equalTo(worthIcon);
    }];
    
    UILabel *CSI300Label = [[UILabel alloc] init];
    CSI300Label.text = @"沪深300";
    CSI300Label.font = [UIFont systemFontOfSize:12];
    CSI300Label.textColor = [UIColor grayColor];
    [footerView addSubview:CSI300Label];
    [CSI300Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(CSI300Icon.mas_right);
        make.centerY.equalTo(worthIcon);
    }];

    
    UIImageView *positionIcon = [[UIImageView alloc] init];
    positionIcon.image = [UIImage imageNamed:@"light_blue_circle"];
    [footerView addSubview:positionIcon];
    [positionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(CSI300Label.mas_right).offset(15);
        make.centerY.equalTo(worthIcon);
    }];
    
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"仓位";
    positionLabel.textColor = [UIColor grayColor];
    positionLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(positionIcon.mas_right);
        make.centerY.equalTo(worthIcon);
    }];
    
}

- (NSDateFormatter *)format{

    if (_format == nil)
    {
        _format = [[NSDateFormatter alloc] init];
    }
    return _format;

}

@end
