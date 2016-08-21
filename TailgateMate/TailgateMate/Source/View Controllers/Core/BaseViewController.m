//
//  BaseViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@implementation BaseViewController

- (id<BaseViewControllerDelegate>)baseDelegate {
    id<BaseViewControllerDelegate> delegate = nil;
    
    UIViewController *parentVC = self.presentingViewController;
    while (parentVC != nil) {
        if ([parentVC conformsToProtocol:@protocol(BaseViewControllerDelegate)]) {
            delegate = (id<BaseViewControllerDelegate>)parentVC;
            break;
        }
        parentVC = parentVC.presentingViewController;
    }
    return delegate;
}

@end
