//
//  MJViewController.m
//  MJAlertDemo
//
//  Created by xundu on 2019/9/20.
//  Copyright © 2019 majia. All rights reserved.
//

#import "MJViewController.h"
#import "MJAlertView.h"

@interface MJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *array;
@end


@implementation MJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 60;
    [self.view addSubview:tableview];
    [tableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"democell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"democell"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.array[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:title messages:@"这是个弹框demo，你想要的都有，欢迎使用！"];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
            
        }
            break;
        case 1:{
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:title messages:@"这是个弹框demo，你想要的都有，欢迎使用！"];
            [alertView addActionTitle:@"取消" actionHandler:^{
                NSLog(@"点击取消按钮");
            }];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
        }
            break;
        case 2:{
          [MJAlertView showAlertWithTitle:@"类方法创建" messages:@"请查看当前信息" buttons:@[@"取消",@"确定"] cancleHandle:^{
                
            } okHandle:^{
                NSLog(@"点击确定按钮");
            }];
        }
            break;
        case 3:{
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:@"" messages:title];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
            
        }
            break;
        case 4:{
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:@"" messages:title];
            [alertView addActionTitle:@"取消" actionHandler:^{
                NSLog(@"点击取消按钮");
            }];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
        }
            break;
        case 5:{
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:@"请输入您的信息" messages:title];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            textField.backgroundColor = [UIColor greenColor];
            [alertView addContentView:textField];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
        }
            break;
        case 6:{
            MJAlertView *alertView = [[MJAlertView alloc] initWithTitle:@"请查看如下" messages:title];
            UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            view.backgroundColor = [UIColor blueColor];
            [alertView addContentView:view];
            [alertView addActionTitle:@"取消" actionHandler:^{
                NSLog(@"点击取消按钮");
            }];
            [alertView addSpecialActionTitle:@"确定" actionHandler:^{
                NSLog(@"点击确定按钮");
            }];
            [alertView showAlert];
            
            
            
        }
            break;
            
        default:
            break;
    }
}
- (NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
        [_array addObject:@"【标题】【信息】【一个按钮】"];
        [_array addObject:@"【标题】【信息】【两个按钮】"];
        [_array addObject:@"【标题】【信息】【类方法默认】"];
        [_array addObject:@"【信息】【一个按钮】"];
        [_array addObject:@"【信息】【两个按钮】"];
        [_array addObject:@"【自定义view】【一个按钮】"];
        [_array addObject:@"【自定义view】【两个按钮】"];
    }
    return _array;
}

@end
