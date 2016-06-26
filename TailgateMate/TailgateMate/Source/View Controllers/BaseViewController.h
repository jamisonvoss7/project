//
//  BaseViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerDelegate.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseDelegate;

@end
