//
//  RRStickChartData.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRStickChartData.h"


@implementation RRStickChartData

@synthesize high = _high;
@synthesize low = _low;
@synthesize date = _date;

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithHigh:(CCFloat)high low:(CCFloat)low date:(NSString *)date {
    self = [self init];

    if (self) {
        self.high = high;
        self.low = low;
        self.date = date;
    }
    return self;
}


@end
