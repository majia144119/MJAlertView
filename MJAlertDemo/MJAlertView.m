//
//  MJAlertView.m
//  MJReader
//
//  Created by xundu on 2019/9/19.
//  Copyright © 2019 majia. All rights reserved.
//

#import "MJAlertView.h"
#import "UIColor+MJColor.h"
#import "Masonry.h"
#import <objc/runtime.h>
@implementation MJAlertViewConfig
+ (instancetype)defaultConfig {
    MJAlertViewConfig *config = nil;
    config = [[MJAlertViewConfig alloc] init];
    [config configDefault];
    return config;
}
- (void)configDefault {
    self.backGroundColor = UIColorWithHexAlpha(@"000000", 0.5);
    self.alertBackColor = [UIColor whiteColor];
    self.titleColor = UIColorWithHex(@"#575656");
    self.messageColor = UIColorWithHex(@"#3B3B3B");
    self.buttonColor = UIColorWithHex(@"#3B3B3B");
    self.buttonHighlightColor = UIColorWithHex(@"f5f5f5");
    self.specialButtonColor = UIColorWithHex(@"FF921D");
    self.lineColor = UIColorWithHex(@"EAEAEA");
    
    self.titleFont = [UIFont boldSystemFontOfSize:16];
    self.messageFont = [UIFont boldSystemFontOfSize:13];
    self.buttonFont = [UIFont boldSystemFontOfSize:14];
    self.specialFont = [UIFont boldSystemFontOfSize:14];
    self.buttonHeight = 44.0f;
    self.alertWidth = 236.0f;
    self.buttonCount = 2;
}

@end


@interface MJAlertView ()
@property (nonatomic,strong) UIView *alertBackView;
@property (nonatomic,strong) UIView *horLine;
@property (nonatomic,strong) UILabel *alertTitleLabel;
@property (nonatomic,strong) UILabel *alertSubTitleLabel;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSMutableArray *actions;
@property (nonatomic,copy)   actionHandler actionHandler;
@property (nonatomic,strong) MJAlertViewConfig *config;
@end
@implementation MJAlertView

- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        if (!self.config) {
            self.config = [MJAlertViewConfig defaultConfig];
        }
        self.backgroundColor  = self.config.backGroundColor;
        [self setAlerMJefaultUI];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message config:(MJAlertViewConfig *)config {
    self.config = config;
    return [self initWithTitle:title messages:message];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (instancetype)showAlertWithTitle:(NSString *)title messages:(NSString *)message buttons:(NSArray<NSString *> *)buttons cancleHandle:(actionHandler)cancleHandle okHandle:(actionHandler)okHandle {
    MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:title messages:message];
    if (buttons.count > 0) {
        [alertView addActionTitle:buttons.firstObject actionHandler:^{
            cancleHandle();
        }];
        [alertView addSpecialActionTitle:buttons.lastObject actionHandler:^{
            okHandle();
        }];
    }else{
        [alertView addActionTitle:@"取消" actionHandler:cancleHandle];
    }
    [alertView showAlert];
    return alertView;
}
+ (instancetype)showAlertWithTitle:(NSString *)title messages:(NSString *)message config:(MJAlertViewConfig *)config buttons:(NSArray<NSString *> *)buttons cancleHandle:(actionHandler)cancleHandle okHandle:(actionHandler)okHandle {
    MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:title messages:message config:config];
    if (buttons.count > 0) {
        [alertView addActionTitle:buttons.firstObject actionHandler:^{
            cancleHandle();
        }];
        [alertView addSpecialActionTitle:buttons.lastObject actionHandler:^{
            okHandle();
        }];
    }else if (buttons.count == 1) {
        [alertView addActionTitle:buttons.firstObject actionHandler:cancleHandle];
    }else{
        [alertView addActionTitle:@"确定" actionHandler:cancleHandle];
    }
    [alertView showAlert];
    return alertView;
}

#pragma mark --default UI
- (void)setAlerMJefaultUI {
    [self addSubview:self.alertBackView];
    self.alertTitleLabel.text = self.title;
    self.alertSubTitleLabel.text = self.message;
    [self setlayoutUI];
    [self sendSubviewToBack:self.alertBackView];
}
- (void)setlayoutUI {
    [self.alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.config.alertWidth);
        make.bottom.equalTo(self.horLine.mas_bottom).offset(self.config.buttonHeight);
    }];
    [self.alertTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertBackView).offset(15);
        make.centerX.equalTo(self.alertBackView);
    }];
    [self.alertSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertTitleLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self.alertBackView);
        make.left.equalTo(self.alertBackView).offset(20);
        make.right.equalTo(self.alertBackView).offset(-20);
    }];
    [self.horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.alertBackView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.alertSubTitleLabel.mas_bottom).offset(20);
    }];
    [self layoutIfNeeded];
}
- (void)actionClick:(UIButton *)sender {
    actionHandler hander = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(sender.titleLabel.text));
    if (hander) {
        hander();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.alertBackView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        self.alertBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)buttonClick:(UIButton *)button Handler:(actionHandler)handler {
    if (handler){
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(button.titleLabel.text), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [button addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)updateAlertButtons {
    if (self.actions.count <= 0) {
        for (UIView *view in self.alertBackView.subviews) {
            [view removeFromSuperview];
        }
        return;
    }
    CGFloat buttonWidth = self.alertBackView.frame.size.width/self.actions.count;
    [self.actions enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertBackView.mas_left).offset(buttonWidth*idx+0.5);
            make.bottom.equalTo(self.alertBackView.mas_bottom);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(self.config.buttonHeight);
        }];
        UIView *verLineView  = [[UIView alloc] init];
        verLineView.backgroundColor = self.config.lineColor;
        [self.alertBackView addSubview:verLineView];
        [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top);
            make.left.equalTo(button.mas_left);
            make.bottom.equalTo(button);
            make.width.mas_equalTo(0.5);
        }];
    }];
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark --public method
- (void)addActionTitle:(NSString *)title actionHandler:(actionHandler)handler {
    UIButton *actionButton = [[UIButton alloc] init];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton setTitleColor:self.config.buttonColor forState:UIControlStateNormal];
    actionButton.titleLabel.font = self.config.buttonFont;
    [actionButton setBackgroundImage:[self imageWithColor:self.config.buttonHighlightColor] forState:UIControlStateHighlighted];
    [self buttonClick:actionButton Handler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    }];
    [self.alertBackView addSubview:actionButton];
    [self.actions addObject:actionButton];
}
- (void)addSpecialActionTitle:(NSString *)title actionHandler:(actionHandler)handler {
    UIButton *actionButton = [[UIButton alloc] init];
    [actionButton setTitle:title forState:UIControlStateNormal];
    [actionButton setTitleColor:self.config.specialButtonColor forState:UIControlStateNormal];
    actionButton.titleLabel.font = self.config.specialFont;
    [actionButton setBackgroundImage:[self imageWithColor:self.config.buttonHighlightColor] forState:UIControlStateHighlighted];
    [self buttonClick:actionButton Handler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    }];
    [self.alertBackView addSubview:actionButton];
    [self.actions addObject:actionButton];
}

- (void)addContentView:(UIView *)view {
    self.alertSubTitleLabel.hidden = YES;
    CGFloat viewHeight = view.frame.size.height;
    [self.alertBackView addSubview:view];
    
    if (self.alertTitleLabel.text == nil || self.alertTitleLabel.text.length<1) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertBackView);
            make.left.equalTo(self.alertBackView).offset(15);
            make.right.equalTo(self.alertBackView).offset(-15);
            make.height.mas_equalTo(viewHeight);
        }];
        [self.horLine mas_updateConstraints:^(MASConstraintMaker *make) {        make.top.equalTo(view.mas_bottom).offset(20);
        }];
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertTitleLabel.mas_bottom).offset(15);
            make.left.equalTo(self.alertBackView).offset(15);
            make.right.equalTo(self.alertBackView).offset(-15);
            make.height.mas_equalTo(viewHeight);
        }];
        [self.horLine mas_updateConstraints:^(MASConstraintMaker *make) {        make.top.equalTo(view.mas_bottom).offset(20);
        }];
    }
}
- (void)showAlert {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showAlertInView:window];
}
- (void)showAlertInView:(UIView *)view {
    if (view == nil||![view isKindOfClass:[UIView class]]) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self updateAlertButtons];
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.alertBackView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
    self.alertBackView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBackView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.alertBackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showCustomView:(UIView *)view {
    if (view == nil || ![view isKindOfClass:[UIView class]]) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.alertBackView removeFromSuperview];
    self.alertBackView = view;
    self.frame = window.bounds;
    [self addSubview:view];
    [self.alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(view.frame.size);
    }];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    self.alertBackView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
    self.alertBackView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBackView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.alertBackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disMiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alertBackView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.alertBackView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.alertBackView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
            self.alertBackView.alpha = 1;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}
#pragma mark --lazy
- (UILabel *)alertTitleLabel {
    if (!_alertTitleLabel) {
        _alertTitleLabel = [[UILabel alloc] init];
        _alertTitleLabel.textColor = self.config.titleColor;
        _alertTitleLabel.font = self.config.titleFont;
        _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertBackView addSubview:_alertTitleLabel];
    }
    return _alertTitleLabel;
}

- (UILabel *)alertSubTitleLabel {
    if (!_alertSubTitleLabel) {
        _alertSubTitleLabel = [[UILabel alloc] init];
        _alertSubTitleLabel.textColor = self.config.messageColor;
        _alertSubTitleLabel.font = self.config.messageFont;
        _alertSubTitleLabel.textAlignment = NSTextAlignmentCenter;
        _alertSubTitleLabel.numberOfLines = 0;
         [self.alertBackView addSubview:_alertSubTitleLabel];
    }
    return _alertSubTitleLabel;
}
- (UIView *)alertBackView {
    if (!_alertBackView) {
        _alertBackView = [[UIView alloc] init];
        _alertBackView.backgroundColor = self.config.alertBackColor;
        _alertBackView.layer.cornerRadius = 8;
        _alertBackView.layer.masksToBounds = YES;
    }
    return _alertBackView;
}

- (UIView *)horLine {
    if (!_horLine) {
        _horLine  = [[UIView alloc] init];
        _horLine.backgroundColor = self.config.lineColor;
        [self.alertBackView addSubview:_horLine];
    }
    return _horLine;
}
- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}
@end

