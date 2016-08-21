//
//  FirebaseStorageServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseStorageServiceProvider.h"

@implementation FirebaseStorageServiceProvider
- (void)saveData:(NSData *)date
          atPath:(NSString *)path
 withContentType:(NSString *)contentType
  withCompletion:(void (^)(BOOL, NSError *))handler {
    FIRStorageReference *ref = [AppManager sharedInstance].firebaseStorageRef;
    ref = [ref child:path];
    
    FIRStorageMetadata *metaDate = [[FIRStorageMetadata alloc] init];
    metaDate.contentType = contentType;
    
    [ref putData:date
        metadata:metaDate
      completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
          handler(!error, error);
    }];
}

- (void)getDataAtPath:(NSString *)path
       withCompletion:(void (^)(NSData *, NSError *))handler {
  
    FIRStorageReference *ref = [AppManager sharedInstance].firebaseStorageRef;
    ref = [ref child:path];

    [ref dataWithMaxSize:INT_MAX completion:handler];
}
@end
