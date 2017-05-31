//
//  AppDelegate.m
//  JKExceptionHandler
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import "AppDelegate.h"
#import "JKExceptionHandler.h"
#import "ViewController.h"
#import "JKSQLiteManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"异常错误报告\n exception_name:  %@\n exception_reason:  \n%@ \n exception_callStackSymbols:  \n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    JKSQLiteManager *manager = [JKSQLiteManager sharedSQLManager];
    [manager insertInto:@"err" columns:@"(err_text)" values:[NSString stringWithFormat:@"('%@')",content]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    InstallUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    self.version = @"v1.0.0";
    
    JKSQLiteManager *manager = [JKSQLiteManager sharedSQLManager];
    [manager databaseAtPath:@"/Users/macmini1/Desktop/crash.sqlite"];
    [manager createTable:"create table if not exists err (_id integer not null primary key AUTOINCREMENT,err_text text not null,err_time TIMESTAMP default (datetime('now', 'localtime')));"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
//    ViewController *vc = [[ViewController alloc] init];
    
    self.window.rootViewController = vc;
    
    
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
