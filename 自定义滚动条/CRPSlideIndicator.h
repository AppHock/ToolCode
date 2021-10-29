//
//  CRPSlideIndicator.h
//  codemaokids_Lite
//
//  Created by 程鹏 on 2021/4/17.
//  Copyright © 2021 codemaocompany. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define shortSideWidth CRPDynamicPositionUtil.sharedInstance.getShortSideWidth
#define longSideWidth  CRPDynamicPositionUtil.sharedInstance.getLongSideWidth
#define CRPCCPadDynamicValue(x) (x/1024.0)*longSideWidth
#define CRPCCDynamicValue(x) ((812 > longSideWidth) ? ((x)/812.0)*longSideWidth : x)

@interface CRPSlideIndicatorConfig : NSObject


@property (nonatomic, assign) CGFloat cursorHeightFactor;

/**
 视图整体的宽度
 */
@property (nonatomic, assign) CGFloat width;
/**
 视图整体的高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 滑块的颜色
 */
@property (nonatomic, strong) UIColor *slideViewColor;
///**
// 滑块的宽度，默认为视图整体宽度width的一半
// */
//@property (nonatomic, assign) CGFloat slideViewWidth;

/**
 滑块的宽度，默认为视图整体宽度width的一半
 */
@property (nonatomic, assign) CGFloat slideViewHeight;

/// 自动隐藏
@property (nonatomic, assign) BOOL autoHide;

/// 创作中心
+ (instancetype)creationCenterSlideConfig;

@end

@interface CRPSlideIndicator : UIView

/**
 视图的相关配置
 */
@property (nonatomic, strong) CRPSlideIndicatorConfig *config;

/**
 初始化方法

 @param config 相关配置
 @return LXSlideIndicator实例
 */
- (instancetype)initWithConfig:(CRPSlideIndicatorConfig *)config;

/**
 相关联的scrollView的滚动事件

 @param scrollView 相关联的scrollView对象
 */
- (void)scrollViewRelativeDidScroll:(UIScrollView *)scrollView;


/// 刷新滑块高度
- (void)refreshIndicatorHeightWithScrollView:(UIScrollView *)scrollView;

// 停止滚动
- (void)stopScroll;

@end

NS_ASSUME_NONNULL_END
