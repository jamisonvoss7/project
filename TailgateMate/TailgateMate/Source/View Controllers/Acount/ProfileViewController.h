//
//  ProfileViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AccountFlowManagementViewController.h"

@protocol ProfileEditDelegateProtocol <NSObject>
- (void)updateEmail:(NSString *)email;
- (void)updateUserName:(NSString *)username;
- (void)updatePhoneNumber:(NSString *)phoneNumber;
- (void)updateName:(NSString *)name;
- (void)finishUpdatingPhone;
- (void)presentAViewController:(UIViewController *)viewController;
@optional
- (void)updatePassword:(NSString *)password;
@end

@interface ProfileViewController : BaseViewController <ProfileEditDelegateProtocol>

@property (nonatomic, weak) IBOutlet UIScrollView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *signoutButton;

@end
