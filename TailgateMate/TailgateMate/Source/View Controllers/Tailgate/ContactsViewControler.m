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
@end

@implementation ContactsViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Contacts";
    self.navbarView.leftButton.text = @"Close";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];

    [self.view addSubview:self.navbarView];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.contacts = [AppManager sharedInstance].accountManager.profileAccount.contacts;
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

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

@end
