//
//  PromotionsFooterView.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/20/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionsFooterView : UIView
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
+ (instancetype)instanceWithDefaultNib;
+ (CGFloat)heightForView;
@end
