//
//  TailgateCreationTableViewCell.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineItemCreationTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (instancetype)instanceWithDefaultNib;

- (void)populateWithTimelineItem:(TimelineItem *)item;

@end
