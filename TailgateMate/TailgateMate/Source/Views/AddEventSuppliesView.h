//
//  AddEventSuppliesView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventSuppliesView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSMutableDictionary *selectedSupplies;

+ (instancetype)instanceFromDefaultNib;
- (void)setTailgateSupplies:(NSArray *)supplies;

@end
