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

@end
