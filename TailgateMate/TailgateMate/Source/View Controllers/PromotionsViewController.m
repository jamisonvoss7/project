//
//  PromotionsViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/20/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "PromotionsViewController.h"
#import "PromotionsFooterView.h"

@interface PromotionsViewController ()
@property (nonatomic) NSArray *promotions;
@end

@implementation PromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
    self.title = @"Promotions";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewIfLoaded];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.promotions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [PromotionsFooterView instanceWithDefaultNib];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [PromotionsFooterView heightForView];
}

- (void)goBack {
    [self.baseDelegate dismissViewController:self];
}

@end
