//
//  BNDataDefine.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BNCommonPanelViewLevel) {
    BNCommonPanelViewLevelDefault = 0, ///< 占位
    BNCommonPanelViewLevelScroll = 1, ///< scrollView 卡顿 Demo
    BNCommonPanelViewLevelTableView = 2, ///< tableView 卡顿 Demo
};
