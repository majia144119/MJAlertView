//
//  MJ_AlertView.h
//  MJReader
//
//  Created by xundu on 2019/9/19.
//  Copyright © 2019 MJ_soft. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface MJAlertViewConfig : NSObject
+ (instancetype)defaultConfig;
@property (nonatomic,strong) UIColor *backGroundColor; //整体的背景色
@property (nonatomic,strong) UIColor *alertBackColor; //alert背景色
@property (nonatomic,strong) UIColor *titleColor; //标题颜色
@property (nonatomic,strong) UIColor *messageColor; //信息颜色
@property (nonatomic,strong) UIColor *buttonColor; //普通按钮字体的颜色
@property (nonatomic,strong) UIColor *specialButtonColor; //特殊按钮字体的颜色
@property (nonatomic,strong) UIColor *buttonHighlightColor;//按钮高亮状态下的颜色
@property (nonatomic,strong) UIColor *lineColor; //分割线颜色

@property (nonatomic,strong) UIFont *titleFont; //标题字体
@property (nonatomic,strong) UIFont *messageFont; //信息字体
@property (nonatomic,strong) UIFont *buttonFont; //普通按钮的字体
@property (nonatomic,strong) UIFont *specialFont;//特殊按钮的字体 默认相等

@property (nonatomic,assign) CGFloat buttonHeight; //按钮的高度
@property (nonatomic,assign) CGFloat alertWidth; //alert宽度 默认：246

@property (nonatomic,assign) NSInteger buttonCount;//横向显示按钮的个数 默认：2


@end

typedef void(^actionHandler)(void);

@interface MJAlertView : UIView

/// 初始化
/// @param title 标题
/// @param message 信息
- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message;


/// 自定义初始化
/// @param title 标题
/// @param message 信息
/// @param config 自定义配置
- (instancetype)initWithTitle:(NSString *)title
                     messages:(NSString *)message
                       config:(MJAlertViewConfig *)config;

/// 类初始化方法
/// @param title 标题
/// @param message 信息
/// @param buttons 按钮个数【只支持两个】
/// @param cancleHandle 取消回调
/// @param okHandle 确定回调
+ (instancetype)showAlertWithTitle:(NSString *)title
                          messages:(NSString *)message
                          buttons:(NSArray <NSString *> *)buttons
                          cancleHandle:(actionHandler)cancleHandle
                          okHandle:(actionHandler)okHandle;


/// 配置
/// @param title 标题
/// @param message 信息
/// @param config 自定义配置
/// @param buttons 按钮个数[最多支持两个]
/// @param cancleHandle 取消回调
/// @param okHandle 确定回调
+ (instancetype)showAlertWithTitle:(NSString *)title
                          messages:(NSString *)message
                          config:(MJAlertViewConfig *)config
                          buttons:(NSArray <NSString *> *)buttons
                          cancleHandle:(actionHandler)cancleHandle
                          okHandle:(actionHandler)okHandle;
/**
 添加按钮

 @param title 标题
 @param handler 点击回调
 */
- (void)addActionTitle:(NSString *)title actionHandler:(actionHandler)handler;
/**
 添加特殊按钮
 
 @param title 标题
 @param handler 点击回调
 */
- (void)addSpecialActionTitle:(NSString *)title actionHandler:(actionHandler)handler;

/**
 添加一个view在信息栏

 @param view 子view
 */
- (void)addContentView:(UIView *)view;

/**
 默认加载到window上
 */
- (void)showAlert;

/**
 自定义加载在view上

 @param view 需要加载的view 不能为空 为空表示加载到window上
 */
- (void)showAlertInView:(UIView *)view;
/**
 展示自定义view
 
 @param view 自定义的view
 */
- (void)showCustomView:(UIView *)view;
/**
 消失View
 */
- (void)disMiss;
@end

NS_ASSUME_NONNULL_END

