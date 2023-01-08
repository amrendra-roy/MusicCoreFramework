//
//  MusicAPIClient.swift
//  MusicCoreFramework
//
//  Created by Amrendra on 13/11/21.
//

import Combine

let genericErrorMessage = "We are facing some technical issue, Please try after 1 hour."

public enum MusicNetworkError: Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case invalidResponse(statusCode: Int?, message: String?)
    case other(Error)

    public func defaultErrorDescription() -> String {
        switch self {
        case .other(let error):
            let message = error.localizedDescription
            return message
        case .invalidResponse(let statusCode, let message):
            print("message = \(String(describing: message))")
            return "Invalid request, Please check your request body and parameter. statusCode = \(String(describing: statusCode))"

        default:
            return genericErrorMessage
        }
    }
    
}

//public enum Result<T, U> where U: Error  {
//    case SuccessAM(T)
//    case FailureAM(U)
//}

/*protocol MusicAPIClient {
    
    func fetch<T: Decodable>(with request: URLRequest, session: URLSessionType) -> AnyPublisher<T, MusicNetworkError>
    func load<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void )
}

extansion MusicAPIClient {

    private var subscriber = Set<AnyCancellable>()

    func fetch<T: Decodable>(with request: URLRequest, session: URLSessionType) -> AnyPublisher<T, MusicNetworkError>  {
        
        return  session.sessionWithConfig().dataTaskPublisher(for: request)
              .tryMap { (data: Data, response: URLResponse) in //tryMap validate provide feature to validate first, if ok then return data oterwise error. while Map does not provide any validation
                  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                      throw URLError(.badServerResponse)
                  }
                  return data
              }
              .decode(type: T.self, decoder: JSONDecoder())
              .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                  return .decodingFailed
                case let urlError as URLError:
                  return .sessionFailed(error: urlError)
                default:
                  return .other(error)
                }
              })
              .eraseToAnyPublisher()
    }
    
    func load<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void )  {
            // 1. Create 'dataTaskPusblisher'(Publisher) to make the API call
            URLSession.shared.dataTaskPublisher(for: request)
                // 2. Use 'map'(Operator) to get the data from the result
                .map { $0.data }
                // 3. Decode the data into the 'Decodable' struct using JSONDecoder
                .decode(type: T.self, decoder: JSONDecoder())
                // 4. Make this process in main thread. (you can do this in background thread as well)
                .receive(on: DispatchQueue.main)
                // 5. Use 'sink'(Subcriber) to get the decoaded value or error, and pass it to completion handler
                .sink { (resultCompletion) in
                    switch resultCompletion {
                    case .failure(let error):
                        completion(.failure(error))
                    case .finished:
                        return
                    }
                } receiveValue: { (resultArr) in
                    completion(.success(resultArr))
                }
                // 6. saving the subscriber into an AnyCancellable Set (without this step this won't work)
                .store(in: &subscriber)
        }
}*/



public protocol MusicGenericResponse: Error, Codable {
    var resCode: Int { get }
    var resDesc: String { get }
    var responseStatus: Bool { get }
    var server_time: String? { get }
}

extension MusicGenericResponse {
    var responseSatus: Bool {
        return (resCode == 200) || (resDesc == "success")
    }
}

public enum URLSessionType {
    case `default`
    case `ephemeral`
    case `background`
    
    func sessionWithConfig() -> URLSession {
        switch self {
        case .`default`:
            let config = URLSessionConfiguration.default
            config.httpMaximumConnectionsPerHost = 30
            config.timeoutIntervalForRequest = 90
            //config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let session = URLSession(configuration: config)
            return session
            
        case .`ephemeral`:
            let config = URLSessionConfiguration.ephemeral
            config.httpMaximumConnectionsPerHost = 60
            config.timeoutIntervalForRequest = 5 * 60
            //config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let session = URLSession(configuration: config)
            return session
            
        case .`background`:
            let config = URLSessionConfiguration.background(withIdentifier: "com.amar.ApiCall.backgoundsession")
            config.httpMaximumConnectionsPerHost = 60
            config.timeoutIntervalForRequest = 5 * 90
            //config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let session = URLSession(configuration: config)
            return session
        }
    }
}
