//
//  AddUserNameAndPhoneViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountFlowManagementViewController.h"

@interface AddUserNameAndPhoneView : UIView

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;

@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

+ (instancetype)instanceWithDefualtNib;

@end
