import Foundation

/// Implementation of a generic-based Slack API client
public class SlackAPIClient {
    private let baseEndpoint = "https://slack.com/api/"
    private let session = URLSession(configuration: .default)
    
    private let apiToken: String
    
    public init(apiToken: String) {
        self.apiToken = apiToken
    }
    
    /// Sends a request to Slack servers, calling the completion method when finished
    public func send<T: APIRequest, U:SlackResponseProtocol & Decodable>(_ request: T,_ responseType: U.Type, completion: @escaping ResultCallback<U.Response>) {
        let endpoint = self.endpoint(for: request)
        let urlEndPoint = URLRequest(url: endpoint)
        let task = session.dataTask(with: urlEndPoint) { data, response, error in
            if let data = data {
                do {
                    let responseData = String(data: data, encoding: String.Encoding.utf8)
                    print(responseData!)
                    // Decode the top level response, and look up the decoded response to see
                    // if it's a success or a failure
                    let slackResponse = try JSONDecoder().decode(responseType, from: data)
                    if let dataContainer = slackResponse.data {
                        completion(.success(dataContainer))
                    } else if let error = slackResponse.error {
                        completion(.failure(SlackError.server(message: error)))
                    } else {
                        completion(.failure(SlackError.decoding))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    /// Encodes a URL based on the given request
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let parameters = try? URLQueryEncoder.encode(request) else { fatalError("Wrong parameters") }
        
        // Construct the final URL with all the previous data
        return URL(string: "\(baseEndpoint)\(request.resourceName)?&token=\(apiToken)&\(parameters)")!
    }
}

