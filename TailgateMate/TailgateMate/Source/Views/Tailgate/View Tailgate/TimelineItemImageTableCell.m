//
//  TimelineItemImageTableCell.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/17/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItemImageTableCell.h"
#import "TimelineServiceProvider.h"
#import "NSDate+Additions.h"

@interface TimelineItemImageTableCell ()
@property (nonatomic) TimelineItem *item;
@property (nonatomic, copy) void (^flagHandler)(TimelineItem *item);
@end

@implementation TimelineItemImageTableCell

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"TimelineItemImageTableCell"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.flagButton addTarget:self
                        action:@selector(flagTapHandler:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)hasBeenFlagged:(void (^)(TimelineItem *))handler {
    self.flagHandler = handler;
}

- (void)populateWithItem:(TimelineItem *)item andTailgateParty:(TailgateParty *)party {
    self.item = item;
    
    self.messageLabel.text = @"";
    self.timeLabel.text = @"";
    self.nameLabel.text = @"";
    
    self.nameLabel.text = item.userDisplayName;
   
    if ([item.tiemStamp withinOneMinute]) {
        self.timeLabel.text = @"Just Now";
    } else if ([item.tiemStamp withinOneHour]) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld min ago", (long)[item.tiemStamp minutesAgo]];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM d";
        self.timeLabel.text = [formatter stringFromDate:item.tiemStamp];
    }
    
    if (item.message.length > 0) {
        self.messageLabel.hidden = NO;
        self.line2.hidden = NO;
        
        self.messageLabel.text = item.message;
    } else {
        self.messageLabel.hidden = YES;
        self.line2.hidden = YES;
    }
}

- (void)popluateWithImage:(UIImage *)image {
    self.itemImageView.image = image;
}

- (void)flagTapHandler:(UIButton *)sender {
    if (self.flagHandler) {
        self.flagHandler(self.item);
    }
}

@end
