//
//  TailgateViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyInfoViewController.h"
#import "TailgateSupplySlider.h"
#import "NavbarView.h"
#import "ContactTableViewCell.h"
#import "TailgateMBPointAnnotation.h"
#import "PinProvider.h"
#import "TailgateParty+Additions.h"
#import "TailgatePartyServiceProvider.H"

@interface TailgatePartyInfoViewController ()
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) TailgateSupplySlider *havesSlider;
@property (nonatomic) TailgateSupplySlider *needsSlider;
@property (nonatomic) TailgateMBPointAnnotation *annotation;
@end

@implementation TailgatePartyInfoViewController

- (id)initWithTailgate:(TailgateParty *)tailgateParty {
    self = [super initWithNibName:@"TailgatePartyInfoViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _tailgateParty = tailgateParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.invitedTableView.delegate = self;
    self.invitedTableView.dataSource = self;
    
    self.mapView.delegate = self;
    
    self.titleLabel.text = [NSString stringWithFormat:@"HOST: %@", self.tailgateParty.hostDisplayName];
    self.lotNumberLabel.text = [NSString stringWithFormat:@"LOT: %@", self.tailgateParty.parkingLot.lotName];
    
    self.partyDesignationLabel.text = [self.tailgateParty stringForFanType];;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h:m a - M/d";
    self.dateLabel.text = [formatter stringFromDate:self.tailgateParty.startDate];
    
    self.detailsLabel.text = self.tailgateParty.details;
    [self.detailsLabel sizeToFit];
    
    CGRect frame = self.detailsLabel.frame;
    frame.origin.x = 10.0f;
    frame.origin.y = self.lotNumberLabel.frame.origin.y + self.lotNumberLabel.frame.size.height + 10.0f;
    self.detailsLabel.frame = frame;
    
    frame = self.mapView.frame;
    frame.origin.y = self.detailsLabel.frame.origin.y + self.detailsLabel.frame.size.height + 10.0f;
    self.mapView.frame = frame;
    self.mapTouchView.frame = frame;
    
    frame = self.invitedTitleLabel.frame;
    frame.origin.y = self.mapView.frame.origin.y + self.mapView.frame.size.height + 10.0f;
    self.invitedTitleLabel.frame = frame;
    
    [self.invitedTableView reloadData];

    frame = self.invitedTableView.frame;
    frame.origin.y = self.invitedTitleLabel.frame.origin.y + self.invitedTitleLabel.frame.size.height + 10.0f;
    frame.size.height = self.invitedTableView.contentSize.height;
    self.invitedTableView.frame = frame;
    
    CGSize size = self.scrollView.contentSize;
    size.height = self.invitedTableView.frame.origin.y + self.invitedTableView.frame.size.height + 30.0f;
    self.scrollView.contentSize = size;
    
    
//    self.havesSlider = [TailgateSupplySlider instanceWitDefaultNib];
//    self.needsSlider = [TailgateSupplySlider instanceWitDefaultNib];
// 
//    self.havesSlider.bounds = self.havesContainer.bounds;
//    [self.havesContainer addSubview:self.havesSlider];
//    
//    self.needsSlider.bounds = self.needsContainer.bounds;
//    [self.needsContainer addSubview:self.needsSlider];
//    
//    [self.havesSlider setSupplies:self.tailgateParty.supplies];
//    [self.needsSlider setSupplies:self.tailgateParty.needs];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.scrollView.frame;
    frame.size.height = self.view.frame.size.height;
    self.scrollView.frame = frame;
    
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service getTailgatePartyFullForId:self.tailgateParty.uid
                          withComplete:^(TailgateParty *party, NSError *error) {
                              if (party) {
                                  self.tailgateParty = party;
                                  [self.invitedTableView reloadData];
                                  
                                  CGRect frame = self.invitedTableView.frame;
                                  frame.origin.y = self.invitedTitleLabel.frame.origin.y + self.invitedTitleLabel.frame.size.height + 10.0f;
                                  frame.size.height = self.invitedTableView.contentSize.height;
                                  self.invitedTableView.frame = frame;
                                  
                                  CGSize size = self.scrollView.contentSize;
                                  size.height = self.invitedTableView.frame.origin.y + self.invitedTableView.frame.size.height + 30.0f;
                                  self.scrollView.contentSize = size;

                                  if (!self.annotation || [self.annotation.party isDifferentThanParty:party]) {
                                      [self.mapView removeAnnotation:self.annotation];
                                    
                                      self.mapView.showsUserLocation = YES;
                                      CLLocationCoordinate2D point = CLLocationCoordinate2DMake([party.parkingLot.location.lat floatValue],
                                                                                                [party.parkingLot.location.lon floatValue]);
                                      [self.mapView setCenterCoordinate:point animated:YES];

                                      TailgateParty *party = self.tailgateParty;
                              
                                      TailgateMBPointAnnotation *annocation = [[TailgateMBPointAnnotation alloc] init];
                                      annocation.coordinate = CLLocationCoordinate2DMake(party.parkingLot.location.lat.doubleValue, party.parkingLot.location.lon.doubleValue);
                                      annocation.title = party.name;
                                      annocation.subtitle = party.parkingLot.lotName;
                                      annocation.uid = party.uid;
                                      annocation.party = party;
                              
                                      self.annotation = annocation;
                              
                                      [self.mapView addAnnotation:annocation];
                                  }
                              } else {
                                  [self showErrorToast:@"Problems occured while getting the tailgate party"];
                              }
                          }];
    
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    // Try to reuse the existing ‘pisa’ annotation image, if it exists
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"flag"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here
    if ( ! annotationImage) {
        TailgateMBPointAnnotation *tailgateAnnotaction = (TailgateMBPointAnnotation *)annotation;
        UIImage *image = [PinProvider imageForTailgateParty:tailgateAnnotaction.party];

        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"flag"];
    }
    
    return annotationImage;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tailgateParty.guests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    if (!cell) {
        cell = [ContactTableViewCell instanceWithDefaultNib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Contact *contact = [self.tailgateParty.guests objectAtIndex:indexPath.row];
    [cell populateWithContact:contact];
    
    return cell;
}

@end
