//
//  BaseViewControllerDelegate.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewControllerDelegate <NSObject>

- (void)dismissViewController:(UIViewController *)viewController;
- (void)addViewController:(UIViewController *)viewController;

@end
