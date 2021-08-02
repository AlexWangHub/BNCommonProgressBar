//
//  BNCommonPanelViewInfo.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCommonPanelViewInfo : NSObject

typedef NS_ENUM(NSUInteger, BNCommonPanelViewLevel);
@property (nonatomic, assign) BNCommonPanelViewLevel level;
@property (nonatomic, copy)   NSString *title;

@end

NS_ASSUME_NONNULL_END
