//
//  AppDelegate.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "WebServiceManager.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    [Fabric with:@[[Crashlytics class]]];

    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AVIYNTMpy8GUd5WYziceXD5RmKwUCD7zRkbftNBBAc3xeOPYUGyJe3msUfIcVCBNJ1G0_MP6uqTKSOj-",
                                                           PayPalEnvironmentSandbox : @"ATuC9q6N96XMU6ZLtWVJ2VaM1jsHXg4nGGrMcPS6gzGcztyICCA9cJjlc4GyFBK_7hKXmKPwZSn2bm-m"}];
    // Override point for customization after application launch.
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    [[WebServiceManager sharedInstance] getAllCategoriesWithCompletionBlock:^(NSArray *array, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        NSDictionary *locatii = [NSDictionary dictionaryWithObject:@"Locatii" forKey:@"titlu"];
//        NSDictionary *cont = [NSDictionary dictionaryWithObject:@"Cont" forKey:@"titlu"];
//        NSDictionary *blog = [NSDictionary dictionaryWithObject:@"Blog" forKey:@"titlu"];
        NSDictionary *allCategories = [NSDictionary dictionaryWithObject:@"Toate categoriile" forKey:@"titlu"];
        NSMutableArray *categories = [[NSMutableArray alloc] initWithArray:array];
        [categories addObject:locatii];
        [categories insertObject:allCategories atIndex:0];
//        [categories addObject:cont];
//        [categories addObject:blog];
        [[WebServiceManager sharedInstance] setListOfCategories:categories];
        [[WebServiceManager sharedInstance] getAllLocationWithCompletionBlock:^(NSArray *array, NSError *error) {
        }];
    }];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
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
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
