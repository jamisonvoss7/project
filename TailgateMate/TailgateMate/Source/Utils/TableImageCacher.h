//
//  TableImageCacher.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/21/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TableImageCacher;

@protocol TableImageCacherDelegate <NSObject>

- (void)tableImageCacher:(TableImageCacher *)loader
    finishedLoadingImage:(UIImage *)image
            forIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableImageCacher:(TableImageCacher *)loader
foundImageInvalidForIndexPath:(NSIndexPath *)indexPath;

- (UIImage *)tableImageCacher:(TableImageCacher *)loader
                   willCache:(UIImage *)image
                forIndexPath:(NSIndexPath *)indexPath;

@end

@interface TableImageCacher : NSObject

@property (nonatomic, weak) id<TableImageCacherDelegate> delegate;
@property (nonatomic, weak) UITableView *tableView;

- (id)initForTable:(UITableView *)tableView delegate:(id<TableImageCacherDelegate>)delegate;

- (UIImage *)lazyLoadImageAtPath:(NSString *)path
                     onIndexPath:(NSIndexPath *)indexPath;

- (void)loadVisibleAssets;

@end

