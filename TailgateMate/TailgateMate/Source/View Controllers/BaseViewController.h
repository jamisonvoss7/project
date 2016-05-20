//
//  BaseViewController.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerDelegate.h"

@interface BaseViewController : UIViewController <BaseViewControllerDelegate>

- (void)startup;

@end
