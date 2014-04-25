//
//  ACAccountStore+ReactiveAccountStore.h
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

@import Accounts.ACAccountStore;

@class RACSignal;

@interface ACAccountStore (ReactiveAccountStore)

- (RACSignal *)rac_requestAccessToAccountsWithType:(ACAccountType *)accountType
                                           options:(NSDictionary *)options;

@end
