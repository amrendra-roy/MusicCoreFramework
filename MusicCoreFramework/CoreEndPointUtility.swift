//
//  CoreEndPointUtility.swift
//  MusicCoreFramework
//
//  Created by Amrendra on 13/11/21.
//

public enum EnvironmentType: String { //CoreEndPointUtility
    case Dev = "beta.beatfeisapp.co.uk:1337"
    case QA = "https://QA"
    case Prod = "139.162.220.28:1337"
}


protocol MusicEndpoint {
    var path: String { get }
    func jsonifiedData() -> Data?
}

extension MusicEndpoint where Self: Codable {
    //Will help to prepare url for API call
    var requestURL: URL {
        let components = URLComponents(string: "http://\(kBaseURL)\(self.path)")
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = kBaseURL
//        components.path = self.path
        return (components?.url!)!
    }
    
    //Will use to prepare Reqeust body as JSON (using encode)
    func jsonifiedData() -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            print("Json request data: \(jsonData)")
            let decodd = try JSONDecoder().decode(UserLoginRequest.self, from: jsonData)
            print("decoded paramter = \(decodd)")
            return jsonData
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

//extension MusicEndpoint {
//    static func search(matching query: String,
//                       sortedBy sorting: Sorting = .recency) -> MusicEndpoint {
//        return MusicEndpoint(
//            //path: "/search/repositories",
//            queryItems: [
//                URLQueryItem(name: "q", value: query),
//                URLQueryItem(name: "sort", value: sorting.rawValue)
//            ]
//        )
//    }
//}
