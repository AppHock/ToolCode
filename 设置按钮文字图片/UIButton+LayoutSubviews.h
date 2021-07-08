//
//  UIButton+Extention.h
//  EduSun
//
//  Created by ZXW on 2017/1/17.
//  Copyright © 2017年 montnets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LayoutSubviews)

typedef enum : NSUInteger {
    ButtonImgViewStyleTop,
    ButtonImgViewStyleLeft,
    ButtonImgViewStyleBottom,
    ButtonImgViewStyleRight,
} ButtonImgViewStyle;


@property(nonatomic,assign) CGFloat lableMaxWidth; //文字最大的宽度

/**
 设置 按钮 图片所在的位置
 
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space   图片跟文字间的间距
 */
- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;



@end
