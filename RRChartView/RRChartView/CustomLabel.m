//
//  CustomLabel.m
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2015年 renrencaopan. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

+ (CustomLabel *)setCustomLabelText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor {

    CustomLabel *customLabel = [[self alloc] init];
    customLabel.text = text;
    customLabel.font = [UIFont systemFontOfSize:font];
    customLabel.textColor = textColor;
    
    return customLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
