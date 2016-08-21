//
//  TailgateTimeLineViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface TailgatePartyTimeLineViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIButton *addItemButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (instancetype)initWithTailgateParty:(TailgateParty *)party;

@end
