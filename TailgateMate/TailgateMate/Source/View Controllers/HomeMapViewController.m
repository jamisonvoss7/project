//
//  ViewController.m
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "HomeMapViewController.h"
#import "LoginViewController.h"
#import "AddEventViewController.h"
#import "ProfileViewController.h"
#import "TailgatePartyServiceProvider.h"
#import "EventViewController.h"

@interface HomeMapViewController ()
@property (nonatomic) CLLocation *initialLocationToUse;
@property (nonatomic) NSArray *parties;
@property (nonatomic) NSMutableDictionary *partyAnnotations;
@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
        
    [self setupCornerButtons];
    
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
            MGLPointAnnotation *annocation = [[MGLPointAnnotation alloc] init];
            annocation.coordinate = CLLocationCoordinate2DMake(party.parkingLot.location.lat.doubleValue, party.parkingLot.location.lon.doubleValue);
            annocation.title = party.name;
            annocation.subtitle = party.parkingLot.lotName;
            
            [self.mapView addAnnotation:annocation];
            
            self.partyAnnotations[party.uid] = annocation;
        }
    }
    
    self.parties = newParties;
}

- (void)upperLeftAction:(UITapGestureRecognizer *)sender {
    AddEventViewController *vc = [[AddEventViewController alloc] init];
    vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    
    [self.baseViewControllerDelegate addViewController:vc];
}

- (void)upperRightAction:(UITapGestureRecognizer *)sender {
    if ([AppManager sharedInstance].accountManager.isAuthenticated) {
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    
        [self.baseViewControllerDelegate addViewController:vc];
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.baseViewControllerDelegate = self.baseViewControllerDelegate;
    
        [self.baseViewControllerDelegate addViewController:vc];
    }
}

- (void)lowerLeftAction:(UITapGestureRecognizer *)sender {

}

- (void)lowerRightActin:(UITapGestureRecognizer *)sender {
    
}


- (CLLocation *)checkForBackUpLocation {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:42.014382613289001 longitude:-93.635700716097716];
    return loc;
}

- (void)setupCornerButtons {
    self.upperLeftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.upperRightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.lowerLeftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.lowerRightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    
    self.upperLeftView.layer.cornerRadius = self.upperLeftView.frame.size.width / 2.0f;
    self.upperRightView.layer.cornerRadius = self.upperRightView.frame.size.width / 2.0f;
    self.lowerLeftView.layer.cornerRadius = self.lowerLeftView.frame.size.width / 2.0f;
    self.lowerRightView.layer.cornerRadius = self.lowerRightView.frame.size.width / 2.0f;
    
    UITapGestureRecognizer *URtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upperRightAction:)];
    URtap.numberOfTapsRequired = 1;
    [self.upperRightView addGestureRecognizer:URtap];
    
    UITapGestureRecognizer *ULTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upperLeftAction:)];
    ULTap.numberOfTapsRequired = 1;
    [self.upperLeftView addGestureRecognizer:ULTap];
    
    UITapGestureRecognizer *othertap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lowerLeftAction:)];
    othertap.numberOfTapsRequired = 1;
    [self.lowerLeftView addGestureRecognizer:othertap];
}

- (NSDictionary *)partiesKeyedById:(NSArray *)parties {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:parties.count];
    for (TailgateParty *party in parties) {
        dict[party.uid] = party;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
