//
//  AddEventSuppliesView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddEventSuppliesView.h"
#import "TailgateSupplyRow.h"
#import "TailgateSupplyButton.h"

@interface AddEventSuppliesView ()
@property (nonatomic, readwrite) NSMutableDictionary *selectedSupplies;
@property (nonatomic) NSArray *availableSupplies;
@end

@implementation AddEventSuppliesView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddEventSuppliesView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.selectedSupplies = [[NSMutableDictionary alloc] init];
}

- (void)setTailgateSupplies:(NSArray *)supplies {
    self.availableSupplies = [NSArray arrayWithArray:supplies];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableSupplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"supplyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"supplyCell"];
    }
    
    TailgateSupply *supply = [self.availableSupplies objectAtIndex:indexPath.row];
    cell.textLabel.text = supply.name;
    
    if ([self.selectedSupplies objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedSupplies objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        [self.selectedSupplies removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
    } else {
        [self.selectedSupplies setObject:[self.availableSupplies objectAtIndex:indexPath.row] forKey:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    [self.tableView reloadData];
}
@end
