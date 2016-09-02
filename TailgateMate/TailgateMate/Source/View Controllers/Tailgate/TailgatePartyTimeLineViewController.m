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
#import "TableImageCacher.h"
#import "TimelineServiceProvider.h"

@interface TailgatePartyTimeLineViewController () <TableImageCacherDelegate, GADBannerViewDelegate>
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) NSArray *timeline;
@property (nonatomic) AddTimelineItemViewController *addItemView;
@property (nonatomic) TableImageCacher *cacher;
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
    
    self.cacher = [[TableImageCacher alloc] initForTable:self.tableView
                                                delegate:self];


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

        NSString *path = [NSString stringWithFormat:@"timelines/%@/images/%@", self.tailgateParty.uid, item.photoId];
        [cell popluateWithImage:[self.cacher lazyLoadImageAtPath:path onIndexPath:indexPath]];
        
        [cell populateWithItem:item andTailgateParty:self.tailgateParty];
        
        [cell hasBeenFlagged:^(TimelineItem *item) {
            [self flagItem:item];
        }];
        
        return cell;
    } else if (item.type == TIMELINEITEMTYPE_MESSAGE) {
        TimelineItemMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineMessageCell"];
        if (!cell) {
            cell = [TimelineItemMessageTableCell instanceWithDefaultNib];
        }
        
        [cell populateWithTimelineItem:item];
        
        [cell hasBeenFlagged:^(TimelineItem *item) {
            [self flagItem:item];
        }];

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
    if ([AppManager sharedInstance].accountManager.isAuthenticated) {
        AddTimelineItemViewController *vc = [[AddTimelineItemViewController alloc] initWithTailgateParty:self.tailgateParty];
        [self.baseDelegate presentViewController:vc];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please create an account or sign in to post on a tailgate."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableImageCacher:(TableImageCacher *)loader finishedLoadingImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath {
    TimelineItemImageTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell popluateWithImage:image];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.cacher loadVisibleAssets];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.cacher loadVisibleAssets];
}

- (void)flagItem:(TimelineItem *)item {
    [self.view showActivityIndicatorWithCurtain:YES];
    
    TimelineServiceProvider *service = [[TimelineServiceProvider alloc] init];
    [service flagTimelineItem:item
              toTailgateParty:self.tailgateParty
                 withComplete:^(BOOL success, NSError *error) {
                     TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
                     [service getTimeLineForTailgate:self.tailgateParty.uid
                                        withComplete:^(NSArray *timeline, NSError *error) {
                                            [self.view hideActivityIndicator];
                                            
                                            self.timeline = [NSArray arrayWithArray:timeline];
                                            [self.tableView reloadData];
                                        }];
                 }];
}

@end
