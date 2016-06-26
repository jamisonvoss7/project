//
//  AddContactsViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//
//

#import "BaseViewController.h"

@interface AddContactsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
