//
//  TailgateMBPointAnnotation.h
//  TailgateMate
//
//  Created by Jamison Voss on 5/28/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Mapbox/Mapbox.h>

@interface TailgateMBPointAnnotation : MGLPointAnnotation

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) TailgateParty *party;

@end
