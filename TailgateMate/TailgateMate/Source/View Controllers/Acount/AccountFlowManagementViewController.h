//
//  AccountFlowManagementViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/24/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, FlowType) {
    FlowTypeFacebook,
    FlowTypeSignUp,
    FlowTypeSignIn,
    FlowTypeNone,
};

typedef enum FlowStep : NSUInteger {
    FlowStepAddUserName,
    FlowStepVerifyPhone,
    FlowStepAddContacts,
    FlowStepDone,
    FlowStepNone
} FlowSetp;

@protocol AccountFlowDelegate <NSObject>

- (void)beginFlowOfType:(FlowType)type;
- (void)showNextFlowStep:(FlowSetp)type withObject:(id)object;
- (void)flowManagerGoBack;
- (void)presentAViewController:(UIViewController *)controller;

@end

@interface AccountFlowManagementViewController : BaseViewController <AccountFlowDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end
