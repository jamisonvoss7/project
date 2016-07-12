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

- (void)loadAccountForkey:(NSString *)uid withComplete:(void (^)(Account *account, NSError *error))handler {
    NSString *path = [NSString stringWithFormat:@"accounts/%@", uid];
    
    [super observeDateAtPath:path
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      Account *account = [Account instanceFromDate:data];
                      self.account = account;
                      handler(account, nil);
                  } else {
                      handler(nil, nil);
                  }
              }];
}

- (void)authenticateWithNewUserCredentials:(UserCredentials *)credentials
                               withCompletion:(void (^)(NSString *uid, NSError *error))handler {
    [[FIRAuth auth] createUserWithEmail:credentials.userName
                               password:credentials.password
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 NSString *uid = user.uid;
                                 
                                 if (uid.length > 0 && !error) {
                                     handler(uid, nil);
                                 } else {
                                     handler(nil, error);
                                 }

                             }];
}

- (void)authenticateWithUserCredentials:(UserCredentials *)credentials
                         withCompletion:(void (^)(NSString *, NSError *))handler {
    [[FIRAuth auth] signInWithEmail:credentials.userName
                           password:credentials.password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (user && !error) {
                                 handler(user.uid, nil);
                             } else {
                                 handler(nil, error);
                             }
                         }];
}

- (void)createAccount:(Account *)account withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"accounts/%@", account.uid];

    [self setData:account
          forPath:path
   withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
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
   withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
       if (!error && ref) {
           handler(YES, nil);
       } else {
           handler(NO, error);
       }
   }];
}
@end
