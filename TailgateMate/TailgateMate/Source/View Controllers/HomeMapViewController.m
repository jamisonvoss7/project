//
//  ViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "HomeMapViewController.h"
#import "AddTailgateViewController.h"
#import "ProfileViewController.h"
#import "TailgatePartyServiceProvider.h"
#import "TailgatePartyViewController.h"
#import "TailgateMBPointAnnotation.h"
#import "PinProvider.h"
#import "Batch.h"
#import "TailgatePartyFilterView.h"
#import "PromotionsViewController.h"
#import "TailgateParty+Additions.h"

@interface HomeMapViewController () <GADBannerViewDelegate>
@property (nonatomic) CLLocation *initialLocationToUse;
@property (nonatomic) NSArray *parties;
@property (nonatomic) NSArray *visibleParties;
@property (nonatomic) NSMutableDictionary *partyAnnotations;
@property (nonatomic) UIImage *redFilledPin;
@property (nonatomic) UIImage *redEmptyPin;
@property (nonatomic) UIImage *blueFilledPin;
@property (nonatomic) UIImage *blueEmptyPin;
@property (nonatomic) UIImage *blackFilledPin;
@property (nonatomic) UIImage *blackEmptyPin;
@property (nonatomic) TailgatePartyFilterView *filterView;
@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.bannerView.adUnitID = @"ca-app-pub-9454622519784206/3692751173";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    self.visibleParties = [[NSArray alloc] init];
    self.partyAnnotations = [[NSMutableDictionary alloc] init];
    
    // If the user turned off location services, don't ask.
    if ([LocationManager isLocationServicesEnabled]
        && [LocationManager isLocationServicesAuthorized]){
        
        [[AppManager sharedInstance].locationManager updateLocationWithComplete:^(CLLocation *location) {
            self.initialLocationToUse = location;
        }];
    } else if ([LocationManager isLocationServicesEnabled]
               && [LocationManager isLocationServicesAuthorizationNotDetermined]) {
        
        [[AppManager sharedInstance].locationManager requestAuthorizationWithComplete:^(BOOL isAuthorized) {
            if (isAuthorized) {
                [[AppManager sharedInstance].locationManager updateLocationWithComplete:^(CLLocation *location) {
                    self.initialLocationToUse = location;
                }];
            } else {
                self.initialLocationToUse = [self checkForBackUpLocation];
            }
        }];
    } else {
        self.initialLocationToUse = [self checkForBackUpLocation];
    }
    
    [self setupButtonBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.filterView = [TailgatePartyFilterView instanceWithDefaultNib];
    CGRect frame = self.filterView.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    frame.origin.y = self.filterButton.superview.frame.origin.y - frame.size.height;
    self.filterView.frame = frame;
    
    self.filterView.hidden = YES;
    [self.view addSubview:self.filterView];

    self.filterView.delegate = self;
    
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
  
    NSMutableArray *allParties = [[NSMutableArray alloc ] init];
    Batch *batch = [Batch create];
    
    [batch addBatchBlock:^(Batch *batch) {
        [service getTailgatePartiesInvitedTo:^(NSArray *parties, NSError *error) {
            if (parties.count > 0) {
                [allParties addObjectsFromArray:parties];
            }
            [batch complete:error];
        }];
    }];
    
    if ([AppManager sharedInstance].accountManager.isAuthenticated) {
        [batch addBatchBlock:^(Batch *batch) {
            [service getUserTailgateParties:^(NSArray *array, NSError *error) {
                if (array.count) {
                    [allParties addObjectsFromArray:array];
                }
                [batch complete:error];
            }];
        }];
    }
    
    [batch addBatchBlock:^(Batch *batch) {
        [service getPublicTailgateParties:^(NSArray *parties, NSError *error) {
            if (parties.count) {
                [allParties addObjectsFromArray:parties];
            }
            [batch complete:error];
        }];
    }];
    
    [batch executeWithComplete:^(NSError *error) {
        self.parties = [NSArray arrayWithArray:allParties];
        [self filterPartiesForFanType:self.filterView.currentType];
        [self processParties:self.visibleParties];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// Map Delegate Methods
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

//- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
//    [mapView setCenterCoordinate:annotation.coordinate animated:YES];
//}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    // Try to reuse the existing ‘pisa’ annotation image, if it exists
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"flag"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here
    if ( ! annotationImage) {
        TailgateMBPointAnnotation *tailgateAnnotaction = (TailgateMBPointAnnotation *)annotation;
        UIImage *image = [PinProvider imageForTailgateParty:tailgateAnnotaction.party];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:[PinProvider nameForPinForTailgateParty:tailgateAnnotaction.party]];
    }
    
    return annotationImage;
}

- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    TailgateMBPointAnnotation *tgAnnotation = (TailgateMBPointAnnotation *)annotation;
    NSString *uid = tgAnnotation.uid;
    TailgateParty *party = [[self partiesKeyedById:self.parties] objectForKey:uid];
    
    TailgatePartyViewController *vc = [[TailgatePartyViewController alloc] initWIthTailgateParty:party];
    [self.baseDelegate presentViewControllerInNavigation:vc];
}

- (void)filderDidUpateToType:(TailgatePartyFanType *)type {
    [self hideFilterView];
    [self filterPartiesForFanType:type];
    [self processParties:self.visibleParties];
}

// Private Methods

- (void)setInitialLocationToUse:(CLLocation *)initialLocationToUse {
    _initialLocationToUse = initialLocationToUse;
    [self.mapView setCenterCoordinate:initialLocationToUse.coordinate animated:NO];
}

- (void)processParties:(NSArray *)newParties {
    NSDictionary *newPartiesDict = [self partiesKeyedById:newParties];
    NSMutableDictionary *oldPartiesDict = [NSMutableDictionary dictionaryWithDictionary:[self partiesKeyedById:self.parties]];
    
    for (NSString *key in newPartiesDict.allKeys) {
        [oldPartiesDict removeObjectForKey:key];
    }
    
    for (NSString *key in oldPartiesDict.allKeys) {
        MGLPointAnnotation *annotation = [self.partyAnnotations objectForKey:key];
        [self.mapView removeAnnotation:annotation];
    }
    
    for (TailgateParty *party in newParties) {
        if (![self.partyAnnotations objectForKey:party.uid]) {
            TailgateMBPointAnnotation *annocation = [[TailgateMBPointAnnotation alloc] init];
            annocation.coordinate = CLLocationCoordinate2DMake(party.parkingLot.location.lat.doubleValue, party.parkingLot.location.lon.doubleValue);
            annocation.title = party.name;
            annocation.subtitle = party.parkingLot.lotName;
            annocation.uid = party.uid;
            annocation.party = party;
            
            [self.mapView addAnnotation:annocation];
            
            self.partyAnnotations[party.uid] = annocation;
        } else {
            TailgateMBPointAnnotation *annocation = self.partyAnnotations[party.uid];
            TailgateParty *oldParty = annocation.party;
            if ([oldParty isDifferentThanParty:party]) {
                [self.mapView removeAnnotation:annocation];
                
                TailgateMBPointAnnotation *newAnnocation = [[TailgateMBPointAnnotation alloc] init];
                newAnnocation.coordinate = CLLocationCoordinate2DMake(party.parkingLot.location.lat.doubleValue, party.parkingLot.location.lon.doubleValue);
                newAnnocation.title = party.name;
                newAnnocation.subtitle = party.parkingLot.lotName;
                newAnnocation.uid = party.uid;
                newAnnocation.party = party;

                [self.mapView addAnnotation:newAnnocation];
                
                self.partyAnnotations[party.uid] = newAnnocation;
            }
        }
    }
}

- (void)addTailgateAction:(UIButton *)sender {
    AddTailgateViewController *vc = [[AddTailgateViewController alloc] init];
    
    [self.baseDelegate presentViewController:vc];
}

- (void)goBackAction:(UIButton *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)filterAction:(UIButton *)sender {
    if (self.filterView.hidden) {
        [self showFilterView];
    } else {
        [self hideFilterView];
    }
}

- (void)searchAction:(UIButton *)sender {
    PromotionsViewController *vc = [[PromotionsViewController alloc] init];
    [self.baseDelegate presentViewControllerInNavigation:vc];
}

- (CLLocation *)checkForBackUpLocation {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:42.014382613289001 longitude:-93.635700716097716];
    return loc;
}

- (void)setupButtonBar {
    [self.addButton addTarget:self
                       action:@selector(addTailgateAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.searchButton addTarget:self
                          action:@selector(searchAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self
                        action:@selector(goBackAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.filterButton addTarget:self
                          action:@selector(filterAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSDictionary *)partiesKeyedById:(NSArray *)parties {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:parties.count];
    for (TailgateParty *party in parties) {
        dict[party.uid] = party;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)showFilterView {
    [UIView animateWithDuration:.25 animations:^{
        self.filterView.hidden = NO;
    }];
}

- (void)hideFilterView {
    [UIView animateWithDuration:.25 animations:^{
        self.filterView.hidden = YES;
    }];
}

- (void)filterPartiesForFanType:(TailgatePartyFanType *)type {
    if (type) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.parties.count];
    
        for (TailgateParty *party in self.parties) {
            if (party.fanType == type) {
                [array addObject:party];
            }
        }
    
        self.visibleParties = [NSArray arrayWithArray:array];
    } else{
        self.visibleParties = self.parties;
    }
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
}
@end
