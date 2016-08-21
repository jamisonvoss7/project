//
//  TimelineItem.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface TimelineItem : FirebaseObject

@property (nonatomic, copy) NSString *userDisplayName;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic) NSDate *tiemStamp;
@property (nonatomic) TimelineItemType *type;

@end
