# ProtocolOrientedNetworking

This project was intended to serve as a Proof of Concept (PoC) for a Protocol Oriented API networking library that is simple in it's implementation and usage. This is not intended to cover all possible cases of use for a networking helper layer, rather than that, it's intended to serve as a learning and explorative implementation of some concepts and prove them ready to be used in production code.
This code is inspired by a production ready and working version of this same approach to tackle a common problem for almost all projects - access network data.
It is not the goal of this project to build a fully fledged networking framework that works for all use case scenarios. Instead, it's intended to be simple and clear, with possibilities to be expanded and re-worked to suit more needs as they show up. It's mostly intended to stay simple and with a very small footprint (20 classes or so...) and to be used for small applications that don't need all the functionality that other networking libraries offer at the expense of being very large and complex.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use this framework, you must implement:
- The 'Configurable' protocol must be implemented as an extension for the AppDelegate class in which you set a base set of values for the client to use in it's NSURLConnection internal connection objects.
This is just a simplified way to have your base API configurations available in the same place and be shared across all application modules as well as to be accessible via a special kind of member access lookup similar to what happens in Objective-c when you use abstract message member lookup to send a message to the instance of the object and you may or may not receive meaningfull data back.
You simply need to have these values stored hardcoded in an AppDelegate extension

```ruby
extension AppDelegate: APIConfigurable {
    var requestTimeout: TimeInterval { return 30 }

    var baseURL: String {
        return "https://gateway.marvel.com:443"
        }

    var basePath: String {
        return "/v1/public/"
        }

    var appVersion: String {
        return Bundle.versionNumber(for: Bundle.main)
        }

    var appQueryParams: [URLQueryItem]? {
        return nil
        }

    var authType: AuthenticationType? { return .querystring }
    var security: [String: String]? {
    let (timestamp, hash) = self.generateRequestHash()
        return ["ts": timestamp, "apikey": self.getPublicKey(), "hash": hash]
        }

    fileprivate func getPublicKey() -> String { return "API PUBLIC KEY" }
    fileprivate func getPrivateKey() -> String { return "API PRIVATE KEY" }

    fileprivate func generateRequestHash() -> (String, String) {
        let timestamp = NSDate().timeIntervalSince1970.toTimestampString()
        let hash = MarvelAPIHelper.MD5("\(timestamp)\(self.getPrivateKey())\(self.getPublicKey())")
        return (timestamp, hash)
        }
}
```

- Define and implement API communication models (structs or classes that conform to Codable) to use as parameters and results for the undelying network client
The prefered way of implementing these API communication models is to create structs that comply to the Codable protocol and declare the structs and it's properties with exactly te same name as the model and properties in the API model. This will give you out of the box JSON parsing and object conversion to your App's models ready to use.
Be aware for reserved words to the language that may lead you to trouble. The solution is simply to provide naming keys relations and let the iOS do the heavy work.

```ruby
struct MarvelImage: Codable {
    let path: String?
    let fileExtension: String?

    private enum CodingKeys : String, CodingKey {
        case path, fileExtension = "extension"
        }
}
```

In the example above, the "extension" property declaration would use a reserved word, so we could not use it (unless we escaped it, but i don't really like that approach as it could lead to masking potential problems later), so all we had to do was to create an enum and declare the coding keys relation to the API response.

- Define and configure the necessary 'Endpoint' (public or authenticated) to meet the necessities of the API you are consuming
This is where the power of the protocols extensions backed by buffed enums to explicitly declare the functionality and it's types in a very straightforward way come in.
Let's look at the endpoint for the Characters.
We start by providing an enum and declare the API interface for this specific part of the system. With enum parameters

```ruby
enum CharactersEndpoint {
    case list_caracters(offset: Int, pageSize: Int)
    case download_image(imageURL: URL)
}

extension CharactersEndpoint: AuthenticatedEndpoint {

    var base: String {
        switch self {
        case .download_image(let imageURL):
            let baseURL = imageURL.absoluteURL.absoluteString.replacingOccurrences(of: imageURL.path, with: "", options: [.caseInsensitive, .regularExpression])
            return baseURL
        default:
            return APIConfiguration.shared.baseURL
            }
    }

    var path: String {
        switch self {
        case .list_caracters:
            return String(format: "%@%@", APIConfiguration.shared.basePath, "characters")
        case .download_image(let imageURL):
            return imageURL.path
            }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .list_caracters:
            return .get
        case .download_image:
            return .get
            }
    }

    var queryParameters: [URLQueryItem]? {
        switch self {
        case .list_caracters(let offset, let pageSize):
            var params = [URLQueryItem]()
            params.append(URLQueryItem(name: "limit", value: String(describing: pageSize)))
            params.append(URLQueryItem(name: "offset", value: String(describing: offset)))
            return params
        case .download_image:
            return nil
            }
    }

    var body: Data? {
        return nil
        }
}
```

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

## Future Work

There are many points that can be changed and re-worked to make this framework more robust and flexible as for the use cases it can serve, let's take for example of functionality that can be further added:
- The possibility to cancel current requests
- The functionality to associante multiple requests to allow them to be canceled all together if one of them fails
- The possibility of retrying requests upon fail
- ... (feel free to add more)

## Author

Pedro Brito, pedroml.brito@gmail.com

## License

ProtocolOrientedNetworking is available under the MIT license. See the LICENSE file for more info.
