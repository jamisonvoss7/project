//
//  AccountService.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountService.h"

@interface AccountService ()
@property (nonatomic, readwrite) Account *account;
@end

@implementation AccountService

- (void)loadAllAccounts {
    NSString *path = [NSString stringWithFormat:@"accounts"];
    
    [super observeDateAtPath:path
              withCompletion:^(FDataSnapshot *data) {
                  if (data) {
                      NSLog(@"%@", data.value);
                  }
              }];

}

- (void)loadAccountForkey:(NSString *)uid withComplete:(void (^)(Account *account, NSError *error))handler {
    NSString *path = [NSString stringWithFormat:@"accounts/%@", uid];
    
    [super observeDateAtPath:path
              withCompletion:^(FDataSnapshot *data) {
                  if (data.exists) {
                      Account *account = [Account instanceFromDate:data];
                      self.account = account;
                      handler(account, nil);
                  } else {
                      handler(nil, nil);
                  }
              }];
}

- (void)authenticateWithUserCredentialsHelper:(UserCredentials *)credentials
                               withCompletion:(void (^)(Account *account, NSError *error))handler {
    Firebase *ref = [AppManager sharedInstance].firebaseRef;

    [ref createUser:credentials.userName
           password:credentials.password
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    NSString *uid = [result objectForKey:@"uid"];
    
    if (uid.length > 0 && !error) {
        Account *account = [[Account alloc] init];
        account.uid = uid;
        handler(account, nil);
    } else {
        handler(nil, error);
    }
}];
    
}

- (void)createAccount:(Account *)account withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"accounts/%@", account.uid];

    [self setData:account
          forPath:path
   withCompletion:^(NSError *error, Firebase *ref) {
       if (!error && ref) {
           handler(YES, nil);
       } else {
           handler(NO, error);
       }
   }];
}

- (void)saveAccount:(Account *)account
       withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"accounts/%@", account.uid];

    [self setData:account
          forPath:path
   withCompletion:^(NSError *error, Firebase *ref) {
       if (!error && ref) {
           handler(YES, nil);
       } else {
           handler(NO, error);
       }
   }];
}
@end
