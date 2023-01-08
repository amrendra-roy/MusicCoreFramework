//
//  MusicServiceManager.swift
//  MusicCoreFramework
//
//  Created by Amrendra on 13/11/21.
//

import Combine

public var kBaseURL = ""
 
public class MusicServiceManager {
    
    //var shared: MusicServiceManager
    
    static var subscriber = Set<AnyCancellable>()
    
    //Singleton class
//    private init() {
//
//    }
    //Will use from out side to setup base url/environment
    public static func configuration(with environment: EnvironmentType = .Dev) { //.Dev is default
        //shared = MusicServiceManager()
        kBaseURL = environment.rawValue
    }
    
    // Return pattern fetch method
    static func fetch<T: Decodable>(with request: URLRequest, session: URLSessionType) -> AnyPublisher<T, MusicNetworkError>  {
        return  session.sessionWithConfig().dataTaskPublisher(for: request)
              .tryMap { (data: Data, response: URLResponse) in //tryMap validate provide feature to validate first, if ok then return data oterwise error. while Map does not provide any validation
                  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                      throw URLError(.badServerResponse)
                  }
                  let jsonData = String(decoding: data, as: UTF8.self)
                  print("JSON response from = \(String(describing: request.url)) \n= \(jsonData)")
                  /*let decoder = JSONDecoder()
                  let jsonInModelTypeT = try? decoder.decode(T.self, from: data)
                  print("jsonInModelTypeT =  = \(String(describing: jsonInModelTypeT)String(describing: ))")*/
                  return data
              }
              .decode(type: T.self, decoder: JSONDecoder()) //
              .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    print("Error whiel fetch = \(error)")
                  return .decodingFailed
                case let urlError as URLError:
                  return .sessionFailed(error: urlError)
                default:
                  return .other(error)
                }
              })
              .eraseToAnyPublisher()
    }

    //https://jeevatamil.medium.com/create-generic-apimanager-with-combine-framework-6456ca04452f
    // call back pattern fetch method
    static func load<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void )  {
            // 1. Create 'dataTaskPusblisher'(Publisher) to make the API call
            URLSession.shared.dataTaskPublisher(for: request)
                // 2. Use 'map'(Operator) to get the data from the result
            .tryMap { (data: Data, response: URLResponse) in //tryMap validate provide feature to validate first, if ok then return data oterwise error. while Map does not provide any validation
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let jsonData = String(decoding: data, as: UTF8.self)
                print("JSON response from = \(String(describing: request.url)) \n= \(jsonData)")
                /*let decoder = JSONDecoder()
                let jsonInModelTypeT = try? decoder.decode(T.self, from: data)
                print("jsonInModelTypeT =  = \(String(describing: jsonInModelTypeT)String(describing: ))")*/
                return data
            }
                // 3. Decode the data into the 'Decodable' struct using JSONDecoder
                .decode(type: T.self, decoder: JSONDecoder())
                // 4. Make this process in main thread. (you can do this in background thread as well)
                .receive(on: DispatchQueue.main)
                // 5. Use 'sink'(Subcriber) to get the decoaded value or error, and pass it to completion handler
                .sink { (resultCompletion) in
                    switch resultCompletion {
                    case .failure(let error):
                        print("Error in while loading = \(error)")
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
    
    //amar need to read this  again
    //https://riteshhh.com/combine/declarative-networking-with-combine/    //for sort form of service manage
    
    //amar read this different pattern of combine api
    //https://gist.github.com/stinger/e8b706ab846a098783d68e5c3a4f0ea5
}

// MARK: - Login services
extension MusicServiceManager {
    public static func loginTestAPI() -> AnyPublisher<UserLoginResponse, MusicNetworkError> {
        let loginReq = UserLoginRequest(email: "amar.roy17@gmail.com", password: "1", sing: "")
        return MusicServiceManager.fetch(with: loginReq.request, session: .default)

        /*result.sink { completion in
            print("completion = \(completion)")
        } receiveValue: { outValue in
            print("out put value = \(outValue)")
        }.store(in: &subscriber)*/

        
    }
    
    public static func loginUserDetail(completion: @escaping (Result<UserLoginResponse, Error>) -> Void ) {
        let loginReq = UserLoginRequest(email: "amar.roy17@gmail.com", password: "1", sing: "")
        return MusicServiceManager.load(with: loginReq.request) { result in
            completion(result)
        }
        /*return load(with: loginReq.request) { (result: Result<UserLoginResponse, Error>) in
                    switch result {
                    case .success(let result):
                        self.userViewModels = result.users.map{ UserViewModel($0) }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }*/
    }
}
