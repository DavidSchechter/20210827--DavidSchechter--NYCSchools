//
//  NYCSchoolModel.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import Foundation
import MapKit

public struct NYCHighSchool: Codable {
    
    //MARK: Private Paramters
    
    public var dbn: String?
    public var schoolName: String?
    public var overviewParagraph: String?
    public var location: String?
    public var website:String?
    public var phoneNumber: String?
    public var satCriticalReadingAvgScore: String?
    public var satMathAvgScore: String?
    public var satWritinAvgScore: String?
    
    //MARK: Public helper Methods
    
    /**
     Merge two NYCHighSchool object.
     
     - Parameter school: A NYCHighSchool  object.
     - Returns A NYCHighSchool  object with the combined data from both
     */
    
    public func merge(_ school: NYCHighSchool?) -> NYCHighSchool {
        var tmp = NYCHighSchool()
        tmp.dbn = dbn ?? school?.dbn
        tmp.schoolName = schoolName ?? school?.schoolName
        tmp.overviewParagraph = overviewParagraph ?? school?.overviewParagraph
        tmp.location = location ?? school?.location
        tmp.website = website ?? school?.website
        tmp.phoneNumber = phoneNumber ?? school?.phoneNumber
        tmp.satCriticalReadingAvgScore = satCriticalReadingAvgScore ?? school?.satCriticalReadingAvgScore
        tmp.satMathAvgScore = satMathAvgScore ?? school?.satMathAvgScore
        tmp.satWritinAvgScore = satWritinAvgScore ?? school?.satWritinAvgScore
        return tmp
    }
    
    /**
     The location string.
     
     - Returns the loocation string without the geo coordinate infomation
     */
    
    public func locationWithoutCoordinate() -> String {
        if let location = location {
            let address = location.components(separatedBy: "(")
            return address[0]
        }
        return ""
    }
    
    /**
     The location coordinate object.
     
     - Returns the loocation as  CLLocationCoordinate2D object
     */
    public func locationWithCoordinate() -> CLLocationCoordinate2D? {
        if let location = location {
            let coordinateString = location.substring(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates {
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
}

extension StringProtocol  {
    func substring<S: StringProtocol>(from start: S, options: String.CompareOptions = []) -> SubSequence? {
        guard let lower = range(of: start, options: options)?.upperBound
        else { return nil }
        return self[lower...]
    }
    func substring<S: StringProtocol, T: StringProtocol>(from start: S, to end: T, options: String.CompareOptions = []) -> SubSequence? {
        guard let lower = range(of: start, options: options)?.upperBound,
            let upper = self[lower...].range(of: end, options: options)?.lowerBound
        else { return nil }
        return self[lower..<upper]
    }
}
