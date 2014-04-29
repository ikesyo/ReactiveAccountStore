# ReactiveAccountStore ![License MIT](http://img.shields.io/badge/license-MIT-green.svg)

[![Analytics](https://ga-beacon.appspot.com/UA-205122-10/ReactiveAccountStore/README.md)](https://github.com/igrigorik/ga-beacon)

[**ReactiveCocoa**](https://github.com/ReactiveCocoa/ReactiveCocoa) support for `Accounts.framework`.

## Usage

Requests access and saves an account:

```objc
ACAccountStore *accountStore = [[ACAccountStore alloc] init];
ACAccountType *type = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

[[[accountStore
    rac_requestAccessToAccountsWithType:type options:nil]
    concat:[RACSignal defer:^{
        ACAccount *account = [accountStore accountsWithAccountType:type][0];
        account.accountDescription = @"description";
        return [accountStore rac_saveAccount:account];
    }]] subscribeError:^(NSError *error) {
        // Failed to save or access was not granted.
    } completed:^{
        // Succeeded to save.
    }];
```

## Requirements

- iOS 6.0+
- OS X 10.8+

## Installation

Let's use [CocoaPods](http://cocoapods.org/).

Add the following line to your Podfile:

```ruby
pod 'ReactiveAccountStore'
```

Then, run the following command in the project direcotry:

```sh
$ pod install
```

## Contributors

Syo Ikeda, [suicaicoca@gmail.com](mailto://suicaicoca@gmail.com)

## License

ReactiveAccountStore is licensed under the MIT license.
