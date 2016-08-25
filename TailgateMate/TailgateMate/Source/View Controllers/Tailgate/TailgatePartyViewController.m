//
//  TailgatePartyViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyViewController.h"
#import "TailgatePartyInfoViewController.h"
#import "TailgatePartyTimeLineViewController.h"
#import "EditTailgateViewController.h"

@interface TailgatePartyViewController () <TabPagerDataSource, TabPagerDelegate>
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) TailgatePartyInfoViewController *infoViewController;
@property (nonatomic) TailgatePartyTimeLineViewController *timelineViewController;
@end

@implementation TailgatePartyViewController

- (id)initWIthTailgateParty:(TailgateParty *)tailgateParty {
    self = [super init];
    if (self) {
        _tailgateParty = tailgateParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
    self.title = self.tailgateParty.name;
    
    if (![self.tailgateParty.hostUserName isEqualToString:[AppManager sharedInstance].accountManager.profileAccount.userName]) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(editParty)];
    }

    self.infoViewController = [[TailgatePartyInfoViewController alloc] initWithTailgate:self.tailgateParty];
    self.timelineViewController = [[TailgatePartyTimeLineViewController alloc] initWithTailgateParty:self.tailgateParty];
    
    [self reloadData];
}

- (NSInteger)numberOfViewControllers {
    return 2;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        return self.infoViewController;
    }
    return self.timelineViewController;
}

- (UIColor *)tabBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)tabColor {
    return [UIColor blackColor];
}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"Info";
    } else {
        return @"Timeline";
    }
}

- (void)goBack {
    [self.baseDelegate dismissViewController:self];
}

- (void)editParty {
    EditTailgateViewController *vc = [[EditTailgateViewController alloc] init];
    vc.party = self.tailgateParty;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
