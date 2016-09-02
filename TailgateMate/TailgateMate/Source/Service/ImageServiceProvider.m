//
//  ImageServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ImageServiceProvider.h"
#import "UIImage+Orientation.h"

@implementation ImageServiceProvider

- (void)saveImage:(UIImage *)image
           atPath:(NSString *)path
   withCompletion:(void (^)(BOOL, NSError *))handler {
    
    image = [image fixOrientation];
    
    [super saveData:UIImagePNGRepresentation(image)
             atPath:path
    withContentType:@"image/png"
     withCompletion:handler];
}

- (void)getImageFromPath:(NSString *)path withCompletion:(void (^)(UIImage *, NSError *))handler {
    [super getDataAtPath:path
         withContentType:@"image/png"
          withCompletion:^(NSData *data, NSError *error) {
              if (data.length > 0) {
                  UIImage *image = [UIImage imageWithData:data];
                  handler(image, nil);
              } else {
                  handler(nil, error);
              }
    }];
}
@end
