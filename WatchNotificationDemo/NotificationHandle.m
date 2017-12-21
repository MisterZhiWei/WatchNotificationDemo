//
//  NotificationHandle.m
//  WatchNotificationDemo
//
//  Created by 刘志伟 on 2017/12/20.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import "NotificationHandle.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationHandle()<UNUserNotificationCenterDelegate>

@end

@implementation NotificationHandle
+(NotificationHandle *) shareInstance{
    static NotificationHandle *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

//注册通知中的action事件
-(void)registerNotificationCategory{
    //带回复的通知事件注册
    /*
     * @param options：设置为UNNotificationActionOptionDestructive 在iWatch上字体是红色
     设置为UNNotificationActionOptionForeground在iWatch上不显示操作按钮
     设置为UNNotificationActionOptionAuthenticationRequired是正常的白色
     * @pram actionWithIdentifier：该ID在收到通知时做操作ID识别用，要求后台推送的通知中需要有
     */
    UNTextInputNotificationAction *replyAction = [UNTextInputNotificationAction actionWithIdentifier:@"replyClick" title:@"回复" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"发送" textInputPlaceholder:@"请输入回复内容.."];
    
    UNNotificationCategory *tapCategory = [UNNotificationCategory categoryWithIdentifier:@"reply" actions:@[replyAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    NSSet *set = [[NSSet alloc]initWithObjects:tapCategory, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:set];
}

-(void)authorizationPushNotificaton:(UIApplication *)application{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self; //必须写代理
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //注册之后的回调
        if (!error && granted) {
            NSLog(@"注册成功...");
        }
        else{
            NSLog(@"注册失败...");
        }
    }];
    
    //获取注册之后的权限设置
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"通知配置信息:\n%@",settings);
    }];
    
    //注册通知获取token
    [application registerForRemoteNotifications];
}

//app通知的点击事件
//只会是用户点击消息才会触发，如果使用户长按（3DTouch）、Action等并不会触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到消息的角标
    NSNumber *badge = content.badge;
    
    //收到消息的body
    NSString *body = content.body;
    
    //收到消息的声音
    UNNotificationSound *sound = content.sound;
    
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    //推送消息的标题
    NSString *title = content.title;
    
    if ([response.notification.request.trigger isKindOfClass:[UNNotificationTrigger class]]) {
        NSLog(@"点击了通知:%@\n",userInfo);
    }
    else{
        NSLog(@"通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //处理消息的事件
    NSString *category = content.categoryIdentifier;
    if ([category isEqualToString:@"reply"]) {
        [self handCommnet:response];
    }
    
    completionHandler();
}

-(void)handCommnet:(UNNotificationResponse *)response{
    NSString *actionType = response.actionIdentifier;
    NSString *textStr = @"";
    
    if ([actionType isEqualToString:@"inputClick"]) {
        UNTextInputNotificationResponse *temp = (UNTextInputNotificationResponse *)response;
        textStr = temp.userText;
    }
    
    NSLog(@"回复的内容是:%@",textStr);
}

@end
