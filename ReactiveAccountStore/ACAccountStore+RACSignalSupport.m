//
//  ACAccountStore+RACSignalSupport.m
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

#import "ACAccountStore+RACSignalSupport.h"
#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACSubscriber.h>

@import Accounts.ACAccountType;

@implementation ACAccountStore (RACSignalSupport)

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
    }] setNameWithFormat:@"-rac_requestAccessToAccountsWithType: %@ options: %@", accountType.identifier, options];
}

- (RACSignal *)rac_saveAccount:(ACAccount *)account
{
    return [[RACSignal createSignal:^ RACDisposable *(id<RACSubscriber> subscriber) {
        [self saveAccount:account withCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];

        return nil;
    }] setNameWithFormat:@"-rac_saveAccount: %@", account];
}

- (RACSignal *)rac_renewCredentialsForAccount:(ACAccount *)account
{
    return [[RACSignal createSignal:^ RACDisposable *(id<RACSubscriber> subscriber) {
        [self renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:@(renewResult)];
                [subscriber sendCompleted];
            }
        }];

        return nil;
    }] setNameWithFormat:@"-rac_renewCredentialsForAccount: %@", account];
}

- (RACSignal *)rac_removeAccount:(ACAccount *)account
{
    return [[RACSignal createSignal:^ RACDisposable *(id<RACSubscriber> subscriber) {
        [self removeAccount:account withCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];

        return nil;
    }] setNameWithFormat:@"-rac_removeAccount: %@", account];
}

@end
