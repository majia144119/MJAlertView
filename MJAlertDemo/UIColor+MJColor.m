//
//  UIColor+MJColor.m
//  MJAlertView
//
//  Created by xundu on 2019/9/20.
//  Copyright © 2019 majia. All rights reserved.
//

#import "UIColor+MJColor.h"

@implementation UIColor (MJColor)
UIColor * UIColorWithHex(NSString *hex){
    return [UIColor hexColor:hex];
};
UIColor * UIColorWithHexAlpha(NSString *hex,CGFloat alpha){
    return [UIColor hexColor:hex alpha:alpha];
}
+ (UIColor *)hexColor:(NSString *)str {
    return [UIColor hexColor:str alpha:1.0];
}
+ (UIColor *)hexColor:(NSString *)str alpha:(CGFloat)alpha {
    NSString *cString = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        NSAssert(NO, @"颜色值不可用");
        return nil;
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) {
        NSAssert(NO, @"颜色值不可用");
        return nil;
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}
@end
