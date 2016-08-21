//
//  TimelineItemType.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define TIMELINEITEMTYPE_MESSAGE [TimelineItemType _MESSAGE]
#define TIMELINEITEMTYPE_IMAGE [TimelineItemType _IMAGE]
#define TIMELINEITEMTYPE_CREATION [TimelineItemType _CREATION]

@interface TimelineItemType : FirebaseEnum

+ (TimelineItemType *)_MESSAGE;
+ (TimelineItemType *)_IMAGE;
+ (TimelineItemType *)_CREATION;

@end
