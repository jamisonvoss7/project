//
//  ViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "HomeMapViewController.h"
#import "LoginViewController.h"
#import "AddTailgateViewController.h"
#import "ProfileViewController.h"
#import "TailgatePartyServiceProvider.h"
#import "TailgateViewController.h"
#import "TailgateMBPointAnnotation.h"

@interface HomeMapViewController ()
@property (nonatomic) CLLocation *initialLocationToUse;
@property (nonatomic) NSArray *parties;
@property (nonatomic) NSMutableDictionary *partyAnnotations;
@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
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
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service getAllTailgateParties:^(NSArray *parties, NSError *error) {
        [self processParties:parties];
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
    if ( ! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage *image = [UIImage imageNamed:@"RedFlag"];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"flag"];
    }
    
    return annotationImage;
}

- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    TailgateMBPointAnnotation *tgAnnotation = (TailgateMBPointAnnotation *)annotation;
    NSString *uid = tgAnnotation.uid;
    TailgateParty *party = [[self partiesKeyedById:self.parties] objectForKey:uid];
    
    TailgateViewController *vc = [[TailgateViewController alloc] initWithTailgate:party];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    [self.baseViewControllerDelegate addViewController:vc];
}

// Private Methods

//- (void)setInitialLocationToUse:(CLLocation *)initialLocationToUse {
//    _initialLocationToUse = initialLocationToUse;
//    [self.mapview setCenterCoordinate:initialLocationToUse.coordinate animated:YES];
//}

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
            
            [self.mapView addAnnotation:annocation];
            
            self.partyAnnotations[party.uid] = annocation;
        }
    }
    
    self.parties = newParties;
}

- (void)addTailgateAction:(UIButton *)sender {
    AddTailgateViewController *vc = [[AddTailgateViewController alloc] init];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    
    [self.baseViewControllerDelegate addViewController:vc];
}

- (void)goBackAction:(UIButton *)sender {
    [self.baseViewControllerDelegate dismissViewController:self];
}

- (void)filterAction:(UIButton *)sender {
    
}

- (void)searchAction:(UIButton *)sender {
    
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

@end
