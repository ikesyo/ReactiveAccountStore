//
//  ACAccountStore+RACSignalSupport.h
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

@import Accounts.ACAccountStore;

@class ACAccount;
@class RACSignal;

@interface ACAccountStore (RACSignalSupport)

- (RACSignal *)rac_requestAccessToAccountsWithType:(ACAccountType *)accountType
                                           options:(NSDictionary *)options;

- (RACSignal *)rac_saveAccount:(ACAccount *)account;

/**
 *  Wraps -renewCredentialsForAccount:completion: with `RACSignal`.
 *
 *  @param account The account to renew credentials.
 *  @return A signal that sends ACAccountCredentialRenewResult wrapped in
 *          NSNumber then completes, or sends error passed to `completionHandler`.
 *          You can get `renewResult` of `completionHandler` by accessing
 *          `next`'s `integerValue`.
 */
- (RACSignal *)rac_renewCredentialsForAccount:(ACAccount *)account;

- (RACSignal *)rac_removeAccount:(ACAccount *)account;

@end
