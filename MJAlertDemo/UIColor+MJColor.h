//
//  UIColor+MJColor.h
//  MJAlertView
//
//  Created by xundu on 2019/9/20.
//  Copyright © 2019 majia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MJColor)
+ (UIColor *)hexColor:(NSString *)str;
+ (UIColor *)hexColor:(NSString *)str alpha:(CGFloat)alpha;
UIColor * UIColorWithHex(NSString *hex);
UIColor * UIColorWithHexAlpha(NSString *hex,CGFloat alpha);
@end

NS_ASSUME_NONNULL_END
