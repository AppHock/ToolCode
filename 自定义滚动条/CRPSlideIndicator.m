//
//  CRPSlideIndicator.m
//  codemaokids_Lite
//
//  Created by 程鹏 on 2021/4/17.
//  Copyright © 2021 codemaocompany. All rights reserved.
//

#import "CRPSlideIndicator.h"
#import "UIButton+CRPButton.h"

@interface CRPSlideIndicator ()

@property (copy, nonatomic) void(^autoDismissBlock)(void);
@property (copy, nonatomic) NSString *lastMark;

@end

@implementation CRPSlideIndicatorConfig
- (instancetype)init
{
    if (self = [super init]) {
        self.cursorHeightFactor = 1;
        self.width = 30;
        self.height = 4;
        self.backgroundColor = [UIColor lightGrayColor];
        self.slideViewColor = [UIColor blueColor];
    }
    return self;
}

+ (instancetype)creationCenterSlideConfig {
    CRPSlideIndicatorConfig *config = [[CRPSlideIndicatorConfig alloc] init];
    config.backgroundColor = RGBA(40, 122, 233, 1);
    config.slideViewColor = RGBA(163, 229, 254, 1);
    config.autoHide = YES;
    return config;
}

@end

@interface CRPSlideIndicator ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *slideView;
@end

@implementation CRPSlideIndicator

- (instancetype)initWithConfig:(CRPSlideIndicatorConfig *)config
{
    if (self = [super init]) {
        self.config = config;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, self.config.width, self.config.height);
    
    //背景视图
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.width, self.config.height)];
    _backgroundView.backgroundColor = self.config.backgroundColor;
    [self addSubview:_backgroundView];
    
    //滑块视图
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.width, [self calcSlideViewHeight])];
    _slideView.backgroundColor = self.config.slideViewColor;
    [self addSubview:_slideView];
    
    _slideView.layer.cornerRadius = self.config.width/2;
    _backgroundView.layer.cornerRadius = self.config.width/2;
    
    self.hidden = YES;
}

- (void)layoutSubviews {
    self.backgroundView.frame = self.bounds;
}

#pragma mark - Private

/**
 计算滑块的宽度

 @return CGFloat
 */
//- (CGFloat)calcSlideViewWidth
//{
//    CGFloat slideViewWidth;
//    if (self.config.slideViewWidth <= 0) {
//        //滑块使用默认宽度，设置为背景视图宽度的一半
//        slideViewWidth = self.config.width * 0.5;
//    } else {
//        //滑块使用定义的宽度
//        slideViewWidth = self.config.slideViewWidth;
//    }
//    return slideViewWidth;
//}

/**
 计算滑块的高度

 @return CGFloat
 */
- (CGFloat)calcSlideViewHeight
{
    //滑块默认宽度，为背景视图高度的一半
    return self.slideView.height ?: self.config.height * 0.5;
}


/**
 滑块响应滑动事件

 @param contentOffset   关联scrollView的contentOffset
 @param contentWidth    关联scrollView的内容区域宽度
 @param scrollViewWidth 关联scrollView的实际宽度
 */
//- (void)slideWithContentOffset:(CGFloat)contentOffset contentWidth:(CGFloat)contentWidth scrollViewWidth:(CGFloat)scrollViewWidth
//{
//    //关联scrollView的内容区域，左侧从0开始的x轴的可滚动区域范围
//    CGFloat scrollAreaWidth = contentWidth - scrollViewWidth;
//    //异常处理
//    if (scrollAreaWidth == 0) {
//        return;
//    }
//    //contentOffset从0到scrollAreaWidth，才响应滑动
//    if (contentOffset < 0 || contentOffset > scrollAreaWidth) {
//        return;
//    }
//
//    //滚动的比例
//    CGFloat scale = contentOffset / scrollAreaWidth;
//
//    //滑块的宽度
//    CGFloat slideViewWidth = [self calcSlideViewWidth];
//    CGFloat blankWidth = self.config.width - slideViewWidth;
//
//    //根据比例，等比计算出滑块的位置
//    CGFloat slideOffset = blankWidth * scale;
//
//    //更新滑块的位置
//    CGRect frame = _slideView.frame;
//    frame.origin.x = slideOffset;
//    _slideView.frame = frame;
//}

/**
 滑块响应滑动事件

 @param contentOffset   关联scrollView的contentOffset
 @param contentHeight    关联scrollView的内容区域高度
 @param scrollViewHeight 关联scrollView的实际高度
 */
- (void)slideWithContentOffset:(CGFloat)contentOffset contentHeight:(CGFloat)contentHeight scrollViewHeight:(CGFloat)scrollViewHeight
{
    CGFloat y = (contentOffset/(contentHeight - scrollViewHeight))*(self.height-self.slideView.height);
    _slideView.y = MIN(self.height-self.slideView.height, MAX(0, y));
}

#pragma mark - Public
- (void)scrollViewRelativeDidScroll:(UIScrollView *)scrollView
{
    self.hidden = scrollView.contentSize.height <= scrollView.height;
    if (self.hidden) return;
    
    [self slideWithContentOffset:scrollView.contentOffset.y contentHeight:scrollView.contentSize.height scrollViewHeight:scrollView.frame.size.height];
}

- (void)refreshIndicatorHeightWithScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height == 0) {
        self.slideView.height = 0;
        return;
    }
    self.hidden = YES;
    self.slideView.height = self.height*(scrollView.height*self.config.cursorHeightFactor/scrollView.contentSize.height);
}

- (void)stopScroll {
    if (!self.config.autoHide) return;
    CMSWeak(self);
    NSString *uuid = [[NSUUID UUID] UUIDString];
    self.lastMark = uuid;
    self.autoDismissBlock = ^{
        if (weak_self.hidden) return;
        [UIView animateWithDuration:0.3 animations:^{
            weak_self.alpha = 0;
        } completion:^(BOOL finished) {
            weak_self.hidden = YES;
            weak_self.alpha = 1;
        }];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(![uuid isEqualToString:self.lastMark]) {
            return;
        }
        cm_exe_block(self.autoDismissBlock);
    });
}

@end
