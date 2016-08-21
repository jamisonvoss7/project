//
//  ViewController.h
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>

#import "TailgatePartyFilterView.h"
#import "BaseViewController.h"

@interface HomeMapViewController : BaseViewController <MGLMapViewDelegate, TailgatePartyFilterViewDelegateProtocol>

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIButton *filterButton;

@end

