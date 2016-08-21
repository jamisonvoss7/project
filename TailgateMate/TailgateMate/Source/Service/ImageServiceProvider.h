//
//  ImageServiceProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseStorageServiceProvider.h"

@interface ImageServiceProvider : FirebaseStorageServiceProvider


- (void)saveImage:(UIImage *)image
           atPath:(NSString *)path
   withCompletion:(void (^)(BOOL success, NSError *error))handler;

- (void)getImageFromPath:(NSString *)path
          withCompletion:(void (^)(NSData *data, NSError *error))handler;


@end
