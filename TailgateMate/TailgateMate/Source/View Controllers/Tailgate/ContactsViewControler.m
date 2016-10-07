//
//  ContactsViewControler.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ContactsViewControler.h"
#import "NavBarView.h"

@interface ContactsViewControler ()
@property (nonatomic) NSArray *contacts;
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic, assign) BOOL isSubPage;
@end

@implementation ContactsViewControler

- (id)initWithContactList:(NSArray *)contactList isSubpage:(BOOL)subpage {
    self = [super init];
    if (self) {
        _contacts = contactList;
        _isSubPage = subpage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    if (!self.isSubPage) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(closeView)];
        self.title = @"Contacts";
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.contacts.count == 0) {
        self.contacts = [AppManager sharedInstance].accountManager.profileAccount.contacts;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.contacts.count > 0) {
        return self.contacts.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contacts.count > 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
  
        Contact *contact = [self.contacts objectAtIndex:indexPath.row];
        cell.textLabel.text = contact.displayName;
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"You haven't added any contacts";        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        return cell;
    }
}

- (void)closeView {
    [self.baseDelegate dismissViewController:self];
}

@end
