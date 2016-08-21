//
//  AddTailgateInvitesView.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTailgateInvitesView.h"

@interface AddTailgateInvitesView ()
@property (nonatomic) NSArray *availableContact;
@end

@implementation AddTailgateInvitesView 

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddTailgateInvitesView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.availableContact = [AppManager sharedInstance].accountManager.profileAccount.contacts;
    self.invitees = [[NSMutableArray alloc] initWithCapacity:self.availableContact.count];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableContact.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [self.availableContact objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = contact.displayName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [self.availableContact objectAtIndex:indexPath.row];
    [self.invitees addObject:contact];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.invitees removeObjectAtIndex:indexPath.row];
}

@end
