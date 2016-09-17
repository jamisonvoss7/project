//
//  AddContactsViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//
//

#import "AccountFlowManagementViewController.h"
#import "AddContactsViewController.h"

@interface AddContactsView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<AccountFlowDelegate> flowDelegate;
@property (nonatomic, weak) id<AddContactsViewControllerDelegate> addContactsVCDelegate;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

+ (instancetype)instanceWithDefaultNib;
- (void)becomesVisible;

@end
