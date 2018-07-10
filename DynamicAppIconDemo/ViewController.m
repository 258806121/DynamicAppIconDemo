//
//  ViewController.m
//  DynamicAppIconDemo
//
//  Created by zhangpeng on 2018/7/10.
//  Copyright © 2018年 zhangpeng. All rights reserved.
//

#import "ViewController.h"
#import "FSAppIconManager.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController () <UNUserNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *name = [FSAppIconManager getCurrentAppIconName];
    NSLog(@"name: %@", name);
}

- (IBAction)changeAppIcon:(id)sender {
    BOOL canChangeAppIcon = [FSAppIconManager canChangeAppIcon];
    NSLog(@"canChangeAppIcon value: %@", canChangeAppIcon?@"YES":@"NO");
    if (!canChangeAppIcon) {
        return;
    }
    [FSAppIconManager changeAppIconWithIconName:@"male" completionHandler:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (IBAction)sendLocalPush:(UIButton *)sender {
    //8s后提醒
//    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:8 repeats:NO];
    
    //每周一早上 8：00 提醒我给起床
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.weekday = 2;
//    components.hour = 8;
//    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
//
//    //需导入定位库   #import <CoreLocation/CoreLocation.h>
//    //一到距离(123.333, 123.344）点20米就喊我下车
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(123.333, 123.344) radius:20 identifier:@"regionidentifier"];
//
//    UNLocationNotificationTrigger *trigger4 = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
    
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"this is Notifications";
        content.subtitle = @"本地通知";
        content.body = @"推送一条本地通知";
        content.badge = @1;
        content.userInfo = @{@"type":@"this is a userNotification"};
        //每小时重复 1 次喊我喝水
        UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
        NSString *requestIdentifier = @"sampleRequest";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger2];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"本地消息推送失败：%@", error);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
