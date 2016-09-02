//
//  ContactCardView.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/27/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactCardView;

@protocol ContactCardDelegate <NSObject>
- (void)cardView:(ContactCardView *)cardView didAddWithContact:(Contact *)contact;
@end

@interface ContactCardView : UIView

@property (nonatomic, weak) id<ContactCardDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *userNamelabel;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (nonatomic) Account *account;

+ (instancetype)instanceWithDefaultNib;

@end
