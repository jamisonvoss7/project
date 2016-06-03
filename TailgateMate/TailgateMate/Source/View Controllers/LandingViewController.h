//
//  LandingViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/19/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewControllerDelegate.h"

@interface LandingViewController : UIViewController

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@property (nonatomic, weak) IBOutlet UIView *createTailgateView;
@property (nonatomic, weak) IBOutlet UIView *viewMapView;
@property (nonatomic, weak) IBOutlet UIButton *profileButton;

@end
