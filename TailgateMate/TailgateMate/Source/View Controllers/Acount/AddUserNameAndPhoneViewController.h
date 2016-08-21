//
//  AddUserNameAndPhoneViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"
#import "AuthenticationDelegate.h"

@interface AddUserNameAndPhoneViewController : BaseViewController

@property (nonatomic, weak) id<AuthenticationDelegate> authDelegate;

@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@end
