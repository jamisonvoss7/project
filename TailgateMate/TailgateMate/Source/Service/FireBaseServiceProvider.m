//
//  FireBaseServiceProvider.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"
#import "Account.h"

@implementation FireBaseServiceProvider

- (void)setData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *, Firebase *))handler {
    Firebase *baseRef = [AppManager sharedInstance].firebaseRef;
    
    baseRef = [baseRef childByAppendingPath:path];
    [baseRef setValue:[data dictionaryRepresentation] withCompletionBlock:handler];
}

- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *, Firebase *))handler {
    Firebase *baseRef = [AppManager sharedInstance].firebaseRef;
    
    baseRef = [baseRef childByAppendingPath:path];
    [baseRef updateChildValues:[data dictionaryRepresentation] withCompletionBlock:handler];
}

- (void)observeDateAtPath:(NSString *)paht withCompletion:(void (^)(FDataSnapshot *))handler {
    Firebase *baseRef = [AppManager sharedInstance].firebaseRef;
    
    baseRef = [baseRef childByAppendingPath:paht];
    [baseRef observeSingleEventOfType:FEventTypeValue
                            withBlock:handler];
}
@end
