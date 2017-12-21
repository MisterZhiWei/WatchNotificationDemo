//
//  ViewController.m
//  WatchNotificationDemo
//
//  Created by 刘志伟 on 2017/12/20.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 150, 40)];
    [sendBtn setTitle:@"点击发通知" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
    [sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

- (void)sendBtnClicked{
    NSLog(@"交互通知3秒后发送");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.body = @"这是一个带交互事件的通知";
    content.title = @"交互事件通知";
    content.categoryIdentifier = @"reply";
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"actionable" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
