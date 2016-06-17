//
//  AddTailgateViewController.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerDelegate.h"

@interface AddTailgateViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@end
