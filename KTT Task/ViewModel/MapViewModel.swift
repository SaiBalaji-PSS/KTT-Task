//
//  MapViewModel.swift
//  KTT Task
//
//  Created by Sai Balaji on 02/07/24.
//

import Foundation

enum MapRoutingError: Error{
    case invalidURL
    case invalidResponse
    case invalidStatusCode(code: Int)
    case decodingError
    
}

extension MapRoutingError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .invalidURL:
            return "The routing URL for given coordinates is invalid \(self.localizedDescription)"
        case .invalidResponse:
            return "The routing response for given coordinates from Google maps server is invalid \(self.localizedDescription)"
        case .invalidStatusCode(let code):
            return "The response from Google maps server is invalid \(code) \(self.localizedDescription)"
        case .decodingError:
            return "Unable to parse JSON Response \(self.localizedDescription)"
        }
    }
}

class MapViewModel{
    private var session = URLSession(configuration: .default)
    
    func drawPolyline(wayPoints: [String])async -> Result<String?,Error> {
        guard let routingURL = self.constructRoutingURL(wayPoints: wayPoints)else{return .failure(MapRoutingError.invalidURL)}
            do{
                let (data,response) = try await session.data(for: URLRequest(url: routingURL))
                guard let httpResposne = response as? HTTPURLResponse else{return .failure(MapRoutingError.invalidResponse)}
                if (200...299).contains(httpResposne.statusCode) == false{return .failure(MapRoutingError.invalidStatusCode(code: httpResposne.statusCode))}
                
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]else {return .failure(MapRoutingError.invalidResponse)}
                        let routes = json["routes"] as? [[String:Any]]
                        let route = routes?.first
                        let polyLine = route?["overview_polyline"] as? [String: Any]
                         let polyLineString = polyLine?["points"] as? String
                            print(polyLineString)
                            return .success(polyLineString)
                        
                    
                }
                catch{
                    return .failure(error)
                }
            }
          
            catch{
                return .failure(error)
            }
            
        }
    
    
    func constructRoutingURL(wayPoints:[String]) -> URL?{
        var temp = wayPoints
        let startPoint = temp.removeFirst()
        let endPoint = temp.removeLast()
        
            let BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?"
            let WAYPOINT_STRING = temp.joined(separator: "|")
            let FINAL_URL = "\(BASE_URL)origin=\(startPoint)&destination=\(endPoint)&waypoints=\(WAYPOINT_STRING)&key=AIzaSyA12C22KUn7S-FMdnz4AFuTi7TMukNDhvI"
            print(FINAL_URL)
        return URL(string: FINAL_URL)
        
    }
    
}
