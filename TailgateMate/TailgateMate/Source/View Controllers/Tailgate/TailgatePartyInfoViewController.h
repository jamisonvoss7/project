//
//  TailgateViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"
#import <Mapbox/Mapbox.h>

@interface TailgatePartyInfoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MGLMapViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lotNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *partyDesignationLabel;

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;

@property (nonatomic, weak) IBOutlet UILabel *invitedTitleLabel;
@property (nonatomic, weak) IBOutlet UITableView *invitedTableView;

@property (nonatomic, weak) IBOutlet UIView *mapTouchView;

//@property (nonatomic, weak) IBOutlet UIView *havesContainer;
//@property (nonatomic, weak) IBOutlet UIView *needsContainer;

- (id)initWithTailgate:(TailgateParty *)tailgateParty;

@end
