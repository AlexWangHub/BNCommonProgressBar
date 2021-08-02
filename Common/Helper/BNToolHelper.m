//
//  BNToolHelper.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNToolHelper.h"

@implementation BNToolHelper

+ (void)caclLotsUselessNums {
    // 测试卡顿使用
    int num = 0;
    for (int i = 0 ; i < 1000; i ++) {
        num ++;
        NSLog(@"BNToolHelper num:%d",num);
    }
}

@end
