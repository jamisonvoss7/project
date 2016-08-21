//
//  PinProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinProvider : NSObject

+ (UIImage *)imageForTailgateParty:(TailgateParty *)party;
+ (NSString *)nameForPinForTailgateParty:(TailgateParty *)party;

@end
