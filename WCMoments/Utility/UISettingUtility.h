//
//  UISettingUtility.h
//  WCMoments
//
//  Created by QianKun on 11/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UISettingUtility : NSObject

+ (UIFont *)profileNickNameFont;
+ (UIColor *)profileNickNameColor;
+ (UIFont *)contentFont;
+ (UIColor *)contentColor;
+ (CGFloat)getLabelHeightWithLabelWidth:(CGFloat)labelWidth contentStr:(NSString *)ctStr labelFont:(UIFont *)font;
+ (CGFloat)getLabelHeightWithLabel:(UILabel *)label;
@end