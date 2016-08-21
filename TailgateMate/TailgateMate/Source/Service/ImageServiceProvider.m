//
//  ImageServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ImageServiceProvider.h"

@implementation ImageServiceProvider

- (void)saveImage:(UIImage *)image
           atPath:(NSString *)path
   withCompletion:(void (^)(BOOL, NSError *))handler {
    
    [super saveData:UIImagePNGRepresentation(image)
             atPath:path
    withContentType:@"image/png"
     withCompletion:handler];
}

- (void)getImageFromPath:(NSString *)path withCompletion:(void (^)(NSData *, NSError *))handler {
    [super getDataAtPath:path withCompletion:handler];
}
@end
