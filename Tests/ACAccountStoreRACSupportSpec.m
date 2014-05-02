//
//  ACAccountStoreReactiveSpec.m
//  ReactiveAccountStore
//
//  Created by Syo Ikeda on 4/25/14.
//  Copyright (c) 2014 Syo Ikeda. All rights reserved.
//

#import "ACAccountStore+RACSignalSupport.h"

SpecBegin(ACAccountStoreRACSupport)

__block id mockStore;
__block ACAccountType *type;

NSError *stubbedError = [NSError errorWithDomain:ACErrorDomain code:ACErrorUnknown userInfo:nil];

beforeEach(^{
    ACAccountStore *store = [[ACAccountStore alloc] init];
    expect(store).notTo.beNil();

    mockStore = [OCMockObject partialMockForObject:store];
    type = [mockStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    expect(type).notTo.beNil();
});

describe(@"-rac_requestAccessToAccountsWithType:options:", ^{
    void (^stubRequestAccessGranted)(BOOL) = ^(BOOL granted) {
        [[[mockStore
            stub]
            andDo:^(NSInvocation *invocation) {
                ACAccountStoreRequestAccessCompletionHandler handler;
                [invocation getArgument:&handler atIndex:4];

                NSError *error = granted ? nil : stubbedError;
                handler(granted, error);
            }]
            requestAccessToAccountsWithType:OCMOCK_ANY
            options:OCMOCK_ANY
            completion:OCMOCK_ANY];
    };

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

describe(@"-rac_saveAccount:", ^{
    __block ACAccount *account;

    void (^stubSaveAccount)(BOOL) = ^(BOOL success) {
        [[[mockStore
            stub]
            andDo:^(NSInvocation *invocation) {
                ACAccountStoreSaveCompletionHandler handler;
                [invocation getArgument:&handler atIndex:3];

                NSError *error = success ? nil : stubbedError;
                handler(success, error);
            }]
            saveAccount:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY];
    };

    beforeEach(^{
        account = [[ACAccount alloc] initWithAccountType:type];
        expect(account).notTo.beNil();
    });

    it(@"should send completed if save succeeded", ^{
        stubSaveAccount(YES);
        RACSignal *signal = [mockStore rac_saveAccount:account];

        __block BOOL completed = NO;
        [signal subscribeCompleted:^{
            completed = YES;
        }];

        expect(completed).will.beTruthy();
    });

    it(@"should send error if save failed", ^{
        stubSaveAccount(NO);
        RACSignal *signal = [mockStore rac_saveAccount:account];

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

describe(@"-rac_renewCredentialsForAccount:", ^{
    __block ACAccount *account;

    void (^stubRenewCredentials)(ACAccountCredentialRenewResult) = ^(ACAccountCredentialRenewResult renewResult) {
        [[[mockStore
            stub]
            andDo:^(NSInvocation *invocation) {
                ACAccountStoreCredentialRenewalHandler handler;
                [invocation getArgument:&handler atIndex:3];

                NSError *error = ((NSInteger)renewResult != NSNotFound) ? nil : stubbedError;
                handler(renewResult, error);
            }]
            renewCredentialsForAccount:OCMOCK_ANY completion:OCMOCK_ANY];
    };

    beforeEach(^{
        account = [[ACAccount alloc] initWithAccountType:type];
        expect(account).notTo.beNil();
    });

    describe(@"should send `renewResult` and complete if error did not occur", ^{
        NSString *name = @"renewResult";

        sharedExamplesFor(name, ^(NSDictionary *data) {
            ACAccountCredentialRenewResult result = [data[name] integerValue];

            NSString *title = [NSString stringWithFormat:@"should send `%ld` and complete", result];
            it(title, ^{
                stubRenewCredentials(result);
                RACSignal *signal = [mockStore rac_renewCredentialsForAccount:account];

                __block ACAccountCredentialRenewResult expected = NSNotFound;
                __block BOOL completed = NO;
                [signal subscribeNext:^(NSNumber *x) {
                    expected = x.integerValue;
                } completed:^{
                    completed = YES;
                }];

                expect(expected).willNot.equal(NSNotFound);
                expect(expected).will.equal(result);
                expect(completed).will.beTruthy();
            });
        });

        itShouldBehaveLike(name, @{ name: @(ACAccountCredentialRenewResultRenewed) });
        itShouldBehaveLike(name, @{ name: @(ACAccountCredentialRenewResultRejected) });
        itShouldBehaveLike(name, @{ name: @(ACAccountCredentialRenewResultFailed) });
    });

    it(@"should send error if error occured", ^{
        stubRenewCredentials(NSNotFound);
        RACSignal *signal = [mockStore rac_renewCredentialsForAccount:account];

        __block BOOL next = NO;
        __block BOOL completed = NO;
        __block NSError *error = nil;
        [signal subscribeNext:^(id x) {
            next = YES;
        } error:^(NSError *e) {
            error = e;
        } completed:^{
            completed = YES;
        }];

        expect(next).will.beFalsy();
        expect(completed).will.beFalsy();
        expect(error).willNot.beNil();
        expect(error.domain).will.equal(ACErrorDomain);
    });
});

describe(@"-rac_removeAccount:", ^{
    __block ACAccount *account;

    void (^stubRemoveAccount)(BOOL) = ^(BOOL success) {
        [[[mockStore
            stub]
            andDo:^(NSInvocation *invocation) {
                ACAccountStoreRemoveCompletionHandler handler;
                [invocation getArgument:&handler atIndex:3];

                NSError *error = success ? nil : stubbedError;
                handler(success, error);
            }]
            removeAccount:OCMOCK_ANY withCompletionHandler:OCMOCK_ANY];
    };

    beforeEach(^{
        account = [[ACAccount alloc] initWithAccountType:type];
        expect(account).notTo.beNil();
    });

    it(@"should send completed if remove succeeded", ^{
        stubRemoveAccount(YES);
        RACSignal *signal = [mockStore rac_removeAccount:account];

        __block BOOL completed = NO;
        [signal subscribeCompleted:^{
            completed = YES;
        }];

        expect(completed).will.beTruthy();
    });

    it(@"should send error if remove failed", ^{
        stubRemoveAccount(NO);
        RACSignal *signal = [mockStore rac_removeAccount:account];

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
