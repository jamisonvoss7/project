//
//  PromotionsViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/20/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface PromotionsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
