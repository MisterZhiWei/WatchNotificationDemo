//
//  NotificationHandle.h
//  WatchNotificationDemo
//
//  Created by 刘志伟 on 2017/12/20.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NotificationHandle : NSObject

+ (NotificationHandle *) shareInstance;

- (void)registerNotificationCategory;

- (void)authorizationPushNotificaton:(UIApplication *)application;

@end
