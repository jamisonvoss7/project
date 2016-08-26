//
//  ProfileView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIView

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UIButton *contactsButton;
@property (nonatomic, weak) IBOutlet UIButton *addContactsButton;
@property (nonatomic, weak) IBOutlet UIView *imageClickReceiver;

+ (instancetype)instanceFromDefaultNib;
- (void)reload;

@end
