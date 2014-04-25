//
//  ACAccountStoreReactiveSpec.m
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

#import "ACAccountStore+RACSignalSupport.h"

SpecBegin(ACAccountStoreRACSupport)

describe(@"-rac_requestAccessToAccountsWithType:options:", ^{
    __block id mockStore;
    __block ACAccountType *type;

    void (^stubRequestAccessGranted)(BOOL) = ^(BOOL granted) {
        [[[mockStore
            stub]
            andDo:^(NSInvocation *invocation) {
                ACAccountStoreRequestAccessCompletionHandler handler;
                [invocation getArgument:&handler atIndex:4];

                NSError *error = granted ? nil : [NSError errorWithDomain:ACErrorDomain code:ACErrorUnknown userInfo:nil];
                handler(granted, error);
            }]
            requestAccessToAccountsWithType:OCMOCK_ANY
            options:OCMOCK_ANY
            completion:OCMOCK_ANY];
    };

    beforeEach(^{
        ACAccountStore *store = [[ACAccountStore alloc] init];
        expect(store).notTo.beNil();

        mockStore = [OCMockObject partialMockForObject:store];
        type = [mockStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        expect(type).notTo.beNil();
    });

    it(@"should send completed if access granted", ^{
        stubRequestAccessGranted(YES);
        RACSignal *signal = [mockStore rac_requestAccessToAccountsWithType:type options:nil];

        __block BOOL completed = NO;
        [signal subscribeCompleted:^{
            completed = YES;
        }];

        expect(completed).will.beTruthy();
    });

    it(@"should send error if access not granted", ^{
        stubRequestAccessGranted(NO);
        RACSignal *signal = [mockStore rac_requestAccessToAccountsWithType:type options:nil];

        __block BOOL completed = NO;
        __block NSError *error = nil;
        [signal subscribeError:^(NSError *e) {
            error = e;
        } completed:^{
            completed = YES;
        }];

        expect(completed).will.beFalsy();
        expect(error).willNot.beNil();
        expect(error.domain).will.equal(ACErrorDomain);
    });
});

SpecEnd
