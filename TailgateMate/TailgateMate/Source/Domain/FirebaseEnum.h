//
//  FireBaseEnum.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseEnum : NSObject <NSCopying>

- (id)initWithString:(NSString *)enumString;
+ (id)findByString:(NSString *)enumString;

@end
