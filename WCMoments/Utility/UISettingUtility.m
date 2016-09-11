//
//  UISettingUtility.m
//  WCMoments
//
//  Created by QianKun on 11/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "UISettingUtility.h"

@implementation UISettingUtility

+ (UIFont *)profileNickNameFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14];
}

+ (UIColor *)profileNickNameColor
{
    return [UIColor blueColor];
}

+ (UIFont *)contentFont
{
    return [UIFont fontWithName:@"Helvetica" size:14];
}

+ (UIColor *)contentColor
{
    return [UIColor blackColor];
}

+ (CGFloat)getLabelHeightWithLabelWidth:(CGFloat)labelWidth contentStr:(NSString *)ctStr labelFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [ctStr boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

+ (CGFloat)getLabelHeightWithLabel:(UILabel *)label
{
    return [self getLabelHeightWithLabelWidth:label.frame.size.width contentStr:label.text labelFont:label.font];
}

@end