//
//  DataManager.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import Foundation

protocol DataManagerProtocol {
    func getSchools(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (_ error: Error?)->())
    func getSchoolsWithSATScores(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (_ error: Error?)->())
}

class DataManager: DataManagerProtocol {
    //MARK: Private Paramters
    
    private let decoder: JSONDecoder = {
        let tmpDecoder = JSONDecoder()
        tmpDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return tmpDecoder
    }()
    
    public init() {}
    
    //MARK: Public Methods
    
    /**
     Fetches all NYC Highschools.
     
     - Parameter completion: A completion method to call on success .
     - Parameter failure: A failure method to call on success .
     */
    func getSchools(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (_ error: Error?)->()) {
        guard let urlString = APIEndpoints.highSchoolsURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            failure(nil)
            return
        }
        guard let url = URL(string: urlString) else {
            failure(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let weakSelf = self {
                if let data = data {
                    if let response = try? weakSelf.decoder.decode([NYCHighSchool].self, from: data) {
                        DispatchQueue.main.async {
                            completion(response)
                        }
                    } else {
                        failure(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    /**
     Fetches all NYC Schools with STA Data.
     
     - Parameter completion: A completion method to call on success .
     - Parameter failure: A failure method to call on success .
     */
    func getSchoolsWithSATScores(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (_ error: Error?)->()) {
        guard let urlString = APIEndpoints.highSchoolsWithSATScoresURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            failure(nil)
            return
        }
        guard let url = URL(string: urlString) else {
            failure(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let weakSelf = self {
                if let data = data {
                    if let response = try? weakSelf.decoder.decode([NYCHighSchool].self, from: data) {
                        DispatchQueue.main.async {
                            completion(response)
                        }
                    } else {
                        failure(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
        }
        task.resume()
    }
}
