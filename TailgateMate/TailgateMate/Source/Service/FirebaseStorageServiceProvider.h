//
//  FirebaseStorageServiceProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseStorageServiceProvider : NSObject

- (void)saveData:(NSData *)date
          atPath:(NSString *)path
 withContentType:(NSString *)contentType
  withCompletion:(void (^)(BOOL success, NSError *error))handler;

- (void)getDataAtPath:(NSString *)path
      withContentType:(NSString *)contentType
       withCompletion:(void (^)(NSData *data, NSError *error))handler;

@end


