//
//  ProfileEditView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface ProfileEditView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<ProfileEditDelegateProtocol> profileDelegate;

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;

+ (instancetype)instanceFromDefaultNib;
- (void)reload;
- (void)closeKeyboards;

@end
