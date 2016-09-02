//
//  AddContactTableViewCell.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactTableViewCell : UITableViewCell 

@property (nonatomic, weak) IBOutlet UILabel *actionLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

+ (instancetype)instanceWithDefaultNib;

@end
