//
//  AddTailgateInvitesView.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTailgateInvitesView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;

@property (nonatomic) NSMutableArray *invitees;

+ (instancetype)instanceWithDefaultNib;

@end
