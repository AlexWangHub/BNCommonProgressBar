//
//  BNDataDefine.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BNCommonPanelViewLevel) {
    BNCommonPanelViewLevelDefault = 0, ///< 占位
    BNCommonPanelViewLevelSystemSlider = 1, ///< 系统Slider
    BNCommonPanelViewLevelCustomProgressBar = 2, ///< 自定义progressBar
};

typedef NS_ENUM(NSUInteger, BNCommonGestureState) {
    BNCommonGestureStateUnKnown,
    BNCommonGestureStateBegin,
    BNCommonGestureStateMove,
    BNCommonGestureStateEnd,
};
