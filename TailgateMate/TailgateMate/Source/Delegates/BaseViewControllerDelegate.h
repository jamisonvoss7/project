//
//  BaseViewControllerDelegate.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewControllerDelegate <NSObject>

- (void)dismissViewController:(UIViewController *)viewController;
- (void)presentViewController:(UIViewController *)viewController;
- (void)presentViewControllerInNavigation:(UIViewController *)viewController;

@end
