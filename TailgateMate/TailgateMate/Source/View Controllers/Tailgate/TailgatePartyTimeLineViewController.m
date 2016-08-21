//
//  TailgateTimeLineViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyTimeLineViewController.h"
#import "TimelineItemMessageTableCell.h"
#import "TimelineItemCreationTableCell.h"
#import "AddTimelineItemViewController.h"
#import "TailgatePartyServiceProvider.h"
#import "TimelineItemImageTableCell.h"

@interface TailgatePartyTimeLineViewController ()
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) NSArray *timeline;
@property (nonatomic) AddTimelineItemViewController *addItemView;
@end

@implementation TailgatePartyTimeLineViewController

- (instancetype)initWithTailgateParty:(TailgateParty *)party {
    self = [super initWithNibName:@"TailgatePartyTimeLineViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _tailgateParty = party;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeline = [[NSArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.addItemButton addTarget:self
                           action:@selector(presentAddItemView)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service getTimeLineForTailgate:self.tailgateParty.uid
                       withComplete:^(NSArray *timeline, NSError *error) {
                           self.timeline = timeline;
                           [self.tableView reloadData];
                       }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeline.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger reversed = self.timeline.count - indexPath.row - 1;
    TimelineItem *item = [self.timeline objectAtIndex:reversed];
    
    if (item.type == TIMELINEITEMTYPE_IMAGE) {
        TimelineItemImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineImageCell"];
        if (!cell) {
            cell = [TimelineItemImageTableCell instanceWithDefaultNib];
        }
        
        [cell populateWithItem:item andTailgateParty:self.tailgateParty];
        
        return cell;
    } else if (item.type == TIMELINEITEMTYPE_MESSAGE) {
        TimelineItemMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineMessageCell"];
        if (!cell) {
            cell = [TimelineItemMessageTableCell instanceWithDefaultNib];
        }
        
        [cell populateWithTimelineItem:item];
        
        return cell;
    } else if (item.type == TIMELINEITEMTYPE_CREATION) {
        TimelineItemCreationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCreationCell"];
        if (!cell) {
            cell = [TimelineItemCreationTableCell instanceWithDefaultNib];
        }
        
        [cell populateWithTimelineItem:item];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger reversed = self.timeline.count - indexPath.row - 1;
    TimelineItem *item = [self.timeline objectAtIndex:reversed];
    if (item.type == TIMELINEITEMTYPE_IMAGE) {
        return [TimelineItemImageTableCell heightForItem:item];
    } else if (item.type == TIMELINEITEMTYPE_MESSAGE) {
        return [TimelineItemMessageTableCell heightForItem:item];
    } else if (item.type == TIMELINEITEMTYPE_CREATION) {
        return [TimelineItemCreationTableCell heightForItem:item];
    }
    return 0;
}

- (void)presentAddItemView {
    if (!self.addItemView) {
        self.addItemView = [[AddTimelineItemViewController alloc] initWithTailgateParty:self.tailgateParty];
    }
  
    [self.baseDelegate presentViewController:self.addItemView];
}

@end
