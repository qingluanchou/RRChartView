//
//  RRLineData.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRBaseData.h"

/**
 保存线图表示用单个线的对象、多条线的时候请使用相应的数据结构保存数据
 */
@interface RRLineData : RRBaseData {
    CCFloat _value;
    NSString *_date;
}

 /** 当前净值*/
@property(assign, nonatomic) CCFloat value;

 /** 日期*/
@property(strong, nonatomic) NSString *date;


/**
 初期化完成对象
 */
- (id)initWithValue:(CCFloat)value date:(NSString *)date;

@end
