//
//  RRLineData.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRLineData.h"


@implementation RRLineData

@synthesize value = _value;
@synthesize date = _date;

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithValue:(CCFloat)value date:(NSString *)date {
    self = [self init];

    if (self) {
        self.value = value;
        self.date = date;
    }
    return self;
}


@end
