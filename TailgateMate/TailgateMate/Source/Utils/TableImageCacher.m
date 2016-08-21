//
//  TableImageCacher.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/21/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TableImageCacher.h"
#import "ImageServiceProvider.h"

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Internal LazyAssetRequest Class
// --------------------------------------------------------------------------------

@interface LazyAssetRequest : NSObject

@property (nonatomic, copy) NSString *path;

- (id)initWithPath:(NSString *)path;

- (BOOL)validate;
- (NSString *)cacheKey;

@end

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Internal LazyAssetRequest Class Definition
// --------------------------------------------------------------------------------

@implementation LazyAssetRequest

- (id)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

- (BOOL)validate {
    if (self.path.length <= 0) {
        return NO;
    }
    return YES;
}

- (NSString *)cacheKey {
    if (self.path.length > 0) {
        return self.path;
    }
    return @"";
}

@end

@interface TableImageCacher ()
@property (nonatomic) NSMutableDictionary *tableAssetsWaiting;
@property (nonatomic) NSMutableDictionary *tableAssetsDownloading;
@property (nonatomic) NSMutableDictionary *sectionAssetsDownloading;
@property (nonatomic) NSCache *cache;
@end

@implementation TableImageCacher
- (id)initForTable:(UITableView *)tableView delegate:(id<TableImageCacherDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.cache = [[NSCache alloc] init];
        self.tableView = tableView;
        self.tableAssetsWaiting = [[NSMutableDictionary alloc] init];
        self.tableAssetsDownloading = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (UIImage *)lazyLoadImageAtPath:(NSString *)path onIndexPath:(NSIndexPath *)indexPath {
    LazyAssetRequest *request = [[LazyAssetRequest alloc] initWithPath:path];
    return [self lazyLoadAssetWithRequest:request onIndexPath:indexPath];
}

- (void)loadVisibleAssets {
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        LazyAssetRequest *assetRequest = [self.tableAssetsWaiting objectForKey:indexPath];
        if (assetRequest) {
            [self fetchAsset:assetRequest onIndexPath:indexPath];
        }
    }
}

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods
// --------------------------------------------------------------------------------

- (UIImage *)lazyLoadAssetWithRequest:(LazyAssetRequest *)request
                          onIndexPath:(NSIndexPath *)indexPath {
    if (![request validate]) {
        return nil;
    }
    
    UIImage *image = [self.cache objectForKey:[request cacheKey]];
    if (!image) {
        if (self.tableView.dragging || self.tableView.decelerating) {
            [self registerLoadingAssetRequest:request onIndexPath:indexPath];
        } else {
            [self fetchAsset:request onIndexPath:indexPath];
        }
    }
    return image;
}

- (void)registerLoadingAssetRequest:(LazyAssetRequest *)request
                        onIndexPath:(NSIndexPath *)indexPath {
    [self.tableAssetsWaiting setObject:request forKey:indexPath];
}

- (void)executeAssetRequest:(LazyAssetRequest *)request
                 completion:(void(^)(NSData *data, NSError *error))handler {
    
    ImageServiceProvider *service = [[ImageServiceProvider alloc] init];
    if (request.path) {
        [service getImageFromPath:request.path
                   withCompletion:^(NSData *data, NSError *error) {
                       handler(data, error);
                   }];
    } else {
        NSLog(@"Unable to lazy fetch asset image. Asset URL and ID are nil.");
    }
}

- (void)fetchAsset:(LazyAssetRequest *)request onIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableAssetsDownloading objectForKey:indexPath]) {
        return;
    }
    
    [self.tableAssetsDownloading setObject:request forKey:indexPath];
    [self executeAssetRequest:request completion:^(NSData *data, NSError *error) {
        if (!error) {
            __block UIImage *image = [UIImage imageWithData:data];
            if ([self.delegate respondsToSelector:@selector(tableImageCacher:willCache:forIndexPath:)]) {
                __weak TableImageCacher *this = self;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    image = [this.delegate tableImageCacher:self
                                                 willCache:image
                                              forIndexPath:indexPath];
                });
            }
            if (image) {
                [self.cache setObject:image forKey:[request cacheKey]];
            }
            [self.tableAssetsDownloading removeObjectForKey:indexPath];
            [self.tableAssetsWaiting removeObjectForKey:indexPath];
            [self finishedLoadingImage:image forIndexPath:indexPath];
        } else {
            [self finishedLoadingImage:nil forIndexPath:indexPath];
        }
    }];
}

- (void)finishedLoadingImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath {
    if ([[self.tableView indexPathsForVisibleRows] containsObject:indexPath]
        || indexPath.row == INT_MAX) {
        __weak TableImageCacher *this = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [this.delegate tableImageCacher:this finishedLoadingImage:image forIndexPath:indexPath];
        });
    }
}

@end
