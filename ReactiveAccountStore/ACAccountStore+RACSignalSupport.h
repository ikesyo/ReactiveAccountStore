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

/**
 *  Wraps -requestAccessToAccountsWithType:options:completion: with `RACSignal`.
 *
 *  @param accountType The account type.
 *  @param options     The option dictionary which is required for certain
 *                     account types (such as Facebook).
 *  @return A signal that complets if access is granted, or sends error.
 */
- (RACSignal *)rac_requestAccessToAccountsWithType:(ACAccountType *)accountType
                                           options:(NSDictionary *)options;

/**
 *  Wraps -saveAccount:withCompletionHandler: with `RACSignal`.
 *
 *  @param account The account to save.
 *  @return A signal that completes if successful, or sends error.
 */
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

/**
 *  Wraps -removeAccount:withCompletionHandler: with `RACSignal`.
 *
 *  @param account The account to remove.
 *  @return A signal that completes if successful, or sends error.
 */
- (RACSignal *)rac_removeAccount:(ACAccount *)account;

@end
