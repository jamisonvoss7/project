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
    
    if (!self.invitees) {
        self.invitees = [[NSMutableArray alloc] initWithCapacity:self.availableContact.count];
    }
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.availableContact.count > 0) {
        return self.availableContact.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.availableContact.count > 0) {
        Contact *contact = [self.availableContact objectAtIndex:indexPath.row];
    
        UITableViewCell *cell = [[UITableViewCell alloc] init];
    
        if ([self.invitees containsObject:contact]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.textLabel.text = contact.displayName;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = @"Add some contacts from your profile page";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.availableContact.count > 0) {
        Contact *contact = [self.availableContact objectAtIndex:indexPath.row];
        if ([self.invitees containsObject:contact]) {
            [self.invitees removeObject:contact];
        } else {
            [self.invitees addObject:contact];
        }
        [self.tableView reloadData];
    }
}


@end
