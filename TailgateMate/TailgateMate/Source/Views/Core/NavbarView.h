//
//  TailgateMate
//
//  Created by Jamison Voss on 5/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavbarView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftButton;
@property (nonatomic, weak) IBOutlet UILabel *rightButton;

+ (instancetype)instanceFromDefaultNib;

@end
