//
//  AddContactTableHeaderView.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactTableHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
+ (instancetype)instanceWithDefaultNib;

@end
