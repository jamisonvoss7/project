//
//  AddTailgateMapView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>

@interface AddTailgateMapView : UIView <MGLMapViewDelegate>

@property (nonatomic, weak) IBOutlet MGLMapView *mapview;

+ (instancetype)instanceFromDefaultNib;

@end
