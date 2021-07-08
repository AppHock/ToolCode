//
//  UIButton+Extention.m
//  EduSun
//
//  Created by ZXW on 2017/1/17.
//  Copyright © 2017年 montnets. All rights reserved.
//

#import "UIButton+LayoutSubviews.h"
#import <math.h>
#import <objc/runtime.h>

@implementation UIButton (LayoutSubviews)


static const char Btn_ImgViewStyle_Key;
static const char Btn_ImgSize_key;
static const char Btn_ImgSpace_key;



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lableMaxWidth = -1;
    }
    return self;
}

- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space
{
    objc_setAssociatedObject(self, &Btn_ImgViewStyle_Key, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &Btn_ImgSpace_key, @(space), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &Btn_ImgSize_key, NSStringFromCGSize(size), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self layoutIfNeeded];
}


+ (void)load
{
    Method m1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method m2 = class_getInstanceMethod([self class], @selector(layoutSubviews1));
    method_exchangeImplementations(m1, m2);
}

- (void)layoutSubviews1
{
    [self layoutSubviews1];
    NSNumber *typeNum = objc_getAssociatedObject(self, &Btn_ImgViewStyle_Key);
    if (typeNum) {
        
        NSNumber *spaceNum = objc_getAssociatedObject(self, &Btn_ImgSpace_key);
        NSString *imgSizeStr = objc_getAssociatedObject(self, &Btn_ImgSize_key);
        CGSize imgSize = self.currentImage ? CGSizeFromString(imgSizeStr) : CGSizeZero;
        
        CGSize labelSize = CGSizeZero;
        if (self.currentTitle) {
            labelSize = self.currentTitle.length ? [self.currentTitle sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}] : CGSizeZero;
        }else if(self.currentAttributedTitle){
            labelSize = CGSizeMake(self.frame.size.width, self.currentAttributedTitle.size.height);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        CGFloat space = (labelSize.width && self.currentImage) ? spaceNum.floatValue : 0;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        CGFloat imgX = 0.0, imgY = 0.0, labelX = 0.0, labelY = 0.0;
        

        switch (typeNum.integerValue) {
            case ButtonImgViewStyleLeft:
            {
                //求出labelSize 最大的宽度
                if (self.lableMaxWidth>0) {
                    labelSize.width = labelSize.width>self.lableMaxWidth?self.lableMaxWidth:labelSize.width;
                }
                
                imgX = (width - imgSize.width - labelSize.width - space)/2.0;
                imgY = (height - imgSize.height)/2.0;
                labelX = imgX + imgSize.width + space;
                labelY = (height - labelSize.height)/2.0;
                
                break;
            }
            case ButtonImgViewStyleTop:
            {
                imgX = (width - imgSize.width)/2.0;
                imgY = (height - imgSize.height - space - labelSize.height)/2.0;
                labelX = (width - labelSize.width)/2;
                labelY = imgY + imgSize.height + space;

                break;
            }
            case ButtonImgViewStyleRight:
            {
                //求出labelSize 最大的宽度
                if (self.lableMaxWidth>0) {
                    labelSize.width = labelSize.width>self.lableMaxWidth?self.lableMaxWidth:labelSize.width;
                }
                
                labelX = (width - imgSize.width - labelSize.width - space)/2.0;
                labelY = (height - labelSize.height)/2.0;
                imgX = labelX + labelSize.width + space;
                imgY = (height - imgSize.height)/2.0;
                

                break;
            }
            case ButtonImgViewStyleBottom:
            {

                labelX = (width - labelSize.width)/2.0;
                labelY = (height - labelSize.height - imgSize.height -space)/2.0;
                imgX = (width - imgSize.width)/2.0;
                imgY = labelY + labelSize.height + space;

                break;
            }
            default:
                break;
        }
        
        self.imageView.frame = CGRectMake(imgX, imgY, imgSize.width, imgSize.height);
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);

    }
}


-(void)setLableMaxWidth:(CGFloat)lableMaxWidth{
    objc_setAssociatedObject(self, @selector(lableMaxWidth), @(lableMaxWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)lableMaxWidth{
    return  [objc_getAssociatedObject(self, @selector(lableMaxWidth)) floatValue];
}



@end
