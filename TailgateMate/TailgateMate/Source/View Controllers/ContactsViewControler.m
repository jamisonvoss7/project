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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.contacts = [NSArray arrayWithArray:[AppManager sharedInstance].accountManager.profileAccount.contacts];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
  
    Contact *contact = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.displayName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

@end
