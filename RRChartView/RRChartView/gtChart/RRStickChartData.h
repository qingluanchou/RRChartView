//
//  RRStickChartData.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRBaseData.h"

/**
 RRStickChart保存柱条表示用的高低值的实体对象
 */
@interface RRStickChartData : RRBaseData {
    CCFloat _high;
    CCFloat _low;
    NSString *_date;
}

 /** 最高仓位*/
@property(assign, nonatomic) CCFloat high;

 /** 最低仓位*/
@property(assign, nonatomic) CCFloat low;

 /** 日期*/
@property(copy, nonatomic) NSString *date;


- (id)initWithHigh:(CCFloat)high low:(CCFloat)low date:(NSString *)date;

@end
