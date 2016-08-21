//
//  ProfileViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *signoutButton;

@end
