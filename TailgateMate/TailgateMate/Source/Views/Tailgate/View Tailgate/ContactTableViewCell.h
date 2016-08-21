//
//  ContactTableViewCell.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contactNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *contactImageView;

+ (instancetype)instanceWithDefaultNib;
- (void)populateWithContact:(Contact *)contact;

@end
