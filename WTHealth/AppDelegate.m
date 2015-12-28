//
//  AppDelegate.m
//  WTHealth
//
//  Created by wadewade on 15/9/30.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <HealthKit/HealthKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //判断是否打开健康应用
    HKHealthStore *healthStore = [[HKHealthStore alloc]init];
    
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"未打开健康应用");
    }
    //这一步是根据需要来获得允许访问的数据类型
    /* [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];//采用这个方法获取数据类型
     这里只给出步数的类型
     */
    NSSet *writeSet = [NSSet setWithArray:[NSArray arrayWithObjects:[HKObjectType workoutType],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],nil]];
    NSSet *readSet = [NSSet setWithArray:[NSArray arrayWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning], nil]];
    
    //提示用户授权应用程序读取和保存给定类型的对象
    [healthStore requestAuthorizationToShareTypes:nil readTypes:readSet completion:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"error = %@",error.description);
        }
      }];
    if ([healthStore authorizationStatusForType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]]) {
        NSLog(@"允许共享这种类型数据");
    }
    ViewController *view = [[ViewController alloc]init];
    self.window.rootViewController = view;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
