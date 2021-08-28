//
//  APIEndpints.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//
import Foundation

struct APIEndpoints {
    static let highSchoolsURL: String = {
        guard let filePath = Bundle.main.path(forResource: "APISettings", ofType: "plist") else {
            fatalError("Couldn't find file 'APISettings.plist'.")
        }
        guard let plist = NSDictionary(contentsOfFile: filePath) as? [String: String] else {
            fatalError("Couldn't convert to [String: String]")
        }
        guard let highSchoolsURL = plist["highSchoolsURL"] else {
            fatalError("Couldn't get `highSchoolsURL` value")
        }
        return highSchoolsURL
    }()
    
    static let highSchoolsWithSATScoresURL: String = {
        guard let filePath = Bundle.main.path(forResource: "APISettings", ofType: "plist") else {
            fatalError("Couldn't find file 'APISettings.plist'.")
        }
        guard let plist = NSDictionary(contentsOfFile: filePath) as? [String: String] else {
            fatalError("Couldn't convert to [String: String]")
        }
        guard let highSchoolsURL = plist["highSchoolsWithSATScoresURL"] else {
            fatalError("Couldn't get `highSchoolsURL` value")
        }
        return highSchoolsURL
    }()
}
