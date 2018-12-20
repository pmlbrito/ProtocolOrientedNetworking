# ProtocolOrientedNetworking

This project was intended to serve as a Proof of Concept (PoC) for a Protocol Oriented API networking library that is simple in it's implementation and usage. This is not intended to cover all possible cases of use for a networking helper layer, rather than that, it's intended to serve as a learning and explorative implementation of some concepts and prove them ready to be used in production code.
This code is inspired by a production ready and working version of this same approach to tackle a common problem for almost all projects.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use this framework, you must implement:
- The 'Configurable' protocol must be implemented as an extension for the AppDelegate class in which you set a base set of values for the client to use in it's NSURLConnection internal connection objects.
- Define and implement API communication models (structs or classes that conform to Codable) to use as parameters and results for the undelying network client
- Define and configure the necessary 'Endpoint' (public or authenticated) to meet the necessities of the API you are consuming
- Define and implement the necessary methods to the 'APIClient' subclasses so that it expresses the available operations, parameterizing the requests and responses with the appropriate models
- Call the APIClient methods and deal with the result in the completion closure blocks

## Requirements

```ruby
iOS SDK version 8.0 and above
```

## Installation

ProtocolOrientedNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ProtocolOrientedNetworking', :git => 'https://github.com/pmlbrito/ProtocolOrientedNetworking.git'
```

## Author

Pedro Brito, pedroml.brito@gmail.com

## License

ProtocolOrientedNetworking is available under the MIT license. See the LICENSE file for more info.
