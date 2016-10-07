//
//  ContactsViewControler.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactsViewControler : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (id)initWithContactList:(NSArray *)contactList isSubpage:(BOOL)subpage;

@end
