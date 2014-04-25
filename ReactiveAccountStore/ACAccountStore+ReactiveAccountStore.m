//
//  ACAccountStore+ReactiveAccountStore.m
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

#import "ACAccountStore+ReactiveAccountStore.h"
#import <ReactiveCocoa/EXTScope.h>
#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACSubscriber.h>

@import Accounts.ACAccountType;

@implementation ACAccountStore (ReactiveAccountStore)

- (RACSignal *)rac_requestAccessToAccountsWithType:(ACAccountType *)accountType
                                           options:(NSDictionary *)options
{
    return [[RACSignal createSignal:^ RACDisposable *(id<RACSubscriber> subscriber) {
        [self
            requestAccessToAccountsWithType:accountType
            options:options
            completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:error];
                }
            }];

        return nil;
    }] setNameWithFormat:@"-rac_requestAccessToAccountsWithType: %@ options: %@",accountType.identifier, options];
}

@end
