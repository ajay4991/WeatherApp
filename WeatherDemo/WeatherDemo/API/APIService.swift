//
//  APIService.swift
//  WeatherDemo
//
//  Created by Ajay Kumar on 08/02/21.
//

import UIKit

import Foundation
class APIService {
    static let sharedInstance = APIService()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    func  get(url :String, parameters: [String: AnyObject]?, success: @escaping(_ json: [String : Any])->Void) {
        
        dataTask?.cancel()
    
        let headers = [
          "authorization": "Basic eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjRmMzU1YTVkOTJmZDgzODU4Zjk3NjM4Y2MzYWZkZTE2NjRmMWUyYzY2NzBkYzY0YzE3ZDU0MWIxZmEyMTIzZjBjNjBmNDc0MmRmMzMxNGMwIn0.eyJhdWQiOiIzIiwianRpIjoiNGYzNTVhNWQ5MmZkODM4NThmOTc2MzhjYzNhZmRlMTY2NGYxZTJjNjY3MGRjNjRjMTdkNTQxYjFmYTIxMjNmMGM2MGY0NzQyZGYzMzE0YzAiLCJpYXQiOjE1OTAxNjM1NTMsIm5iZiI6MTU5MDE2MzU1MywiZXhwIjoxNjIxNjk5NTUzLCJzdWIiOiIyMyIsInNjb3BlcyI6W119.z0vUSAj-vDS2r1uyk5o_-B0Jvut3ZSMmqoTlKgasMtIbX9xzhupN0TDQ_TbU-od-hmjB9J4rF2b1sQC9xI1gYouUEAFAN7sXRlQB9NCEiZXOhtIAgYV_hUre83Ea-0XUVRYQWoEAqcClLjTjCN3c2d1uYVBTtzyvDBRv5mKNcl1CgLHWB8hk9HTM2C7CW4dGfCe5OpWOGG72arvA3lKlpf924ru3ZMs4zZSbbgT4kXmG5M98FUaNk-x9l30xXcEq6s-81b3eyVD_-TKSLi0dGsqbojmc8gadAoOdF7e8NREGGEG40oqldA0HoU3FoQ6jLZkqGqzLb25ic_tAIbrSw1jVZzqgLmQXbbE4ywylrdi9edqyXKTVgJujcjmH_uE5n9odTQj6GhDnk7QAjwPwCS5HgHh4LqfcD1DObPmvCm_v1XZoWG5qd1eYioxJ4ns1xLyfnX_1IOd878hjSL5hVIs2KhtyKhW4CyjBNmv4oswQE-Drcc-pnd2jorMFQm2IB2HhHbe40Wyfo3Qnce81uX_hL_mPtLtezl8THfscpksgcNL4R-6Qv38FO2-oGZjMhG6-Nm6I7Up-8mMEKRn2ikFKHJ3HLlcBKsEB9IsiKqRoWII4b3EOJ9BQwdS-97D2cOHekpbZN7GzTaJLoJ2yy9UfNpJrK1yeuZ4RZEo8CKs"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            //print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            //print(httpResponse)
            
            DispatchQueue.main.async {
                if let data = data {
                                                if let stringData = String(data: data, encoding: String.Encoding.ascii) {
                                                    if let jsonData = stringData.data(using: String.Encoding.utf8) {
                                                        do {
                                                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                                            print("json: \(json)")
                                                            success(json)
                                                        
                                                            
                                                        } catch {
                                                            NSLog("ERROR \(error.localizedDescription)")
                                                        }
                                                    }
                                                }
                                            }
            }
            
          }
        })

        dataTask.resume()
    }
}

