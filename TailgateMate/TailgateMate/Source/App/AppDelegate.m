//
//  AppDelegate.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FireBaseServiceProvider.h"
#import "AppManager.h"
#import "RootViewController.h"

@interface AppDelegate ()
@property (nonatomic) RootViewController *rootViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [FIRApp configure];

    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    self.rootViewController = [[RootViewController alloc] init];
    
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    [self initialize];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
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

- (void)initialize {
    [[AppManager sharedInstance] initAppWIthComplete:^(BOOL success, NSError *error) {
        [self.rootViewController startup];
    }];
}
@end
