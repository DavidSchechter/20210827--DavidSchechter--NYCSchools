//
//  NYCSchoolsViewModel.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit
import Combine

protocol NYCSchoolsViewModelProtocol {
    init(dataManager: DataManagerProtocol)
    
    var dataManager: DataManagerProtocol { get }
    var modelPublisher: CurrentValueSubject<[NYCHighSchool], Never> { get }
    var filteredPublisher: CurrentValueSubject<[NYCHighSchool]?, Never> { get }
    var titlePublisher: AnyPublisher<String, Never> { get }
    func getData()
    func filterByName(_ searchString: String?)
}


class NYCSchoolsViewModel: NYCSchoolsViewModelProtocol {
    
    var titlePublisher: AnyPublisher<String, Never> {
        Just("NYC High Schools").eraseToAnyPublisher()
    }
    var modelPublisher: CurrentValueSubject<[NYCHighSchool], Never> = CurrentValueSubject<[NYCHighSchool], Never>([NYCHighSchool]())
    var filteredPublisher: CurrentValueSubject<[NYCHighSchool]?, Never> = CurrentValueSubject<[NYCHighSchool]?, Never>(nil)
    let dataManager: DataManagerProtocol
        
    required init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    /**
     Make calls to the serive to fetch all appropriate date. Data is returned via the modelPublisher
     */
    func getData() {
        dataManager.getSchools { [weak self] schools in
            self?.dataManager.getSchoolsWithSATScores(completion: { [weak self] schoolsWithSATData in
                let schools: [NYCHighSchool] = schools.compactMap { school in
                    let schoolWithSATData = schoolsWithSATData.first { schoolWithSATData in
                        school.dbn == schoolWithSATData.dbn
                    }
                    return school.merge(schoolWithSATData)
                }
                self?.modelPublisher.send(schools)
            }, failure: { [weak self] error in
                self?.showServiceError(error)
            })
        } failure: { [weak self] error in
            self?.showServiceError(error)
        }
    }
    
    /**
     Filters the data based on the provided search string. Data is returned via the filteredPublisher
     
     - Parameter searchString: the substring of a name of a school.
     */
    func filterByName(_ searchString: String?) {
        if let searchString = searchString, !searchString.isEmpty {
            let filtered = modelPublisher.value.filter { school in
                school.schoolName?.lowercased().contains(searchString.lowercased()) ?? false
            }
            filteredPublisher.send(filtered)
        } else {
            filteredPublisher.send(nil)
            modelPublisher.send(modelPublisher.value)
        }
    }
    
    /**
     Presents an alert with a provided error object
     */
    private func showServiceError(_ error: Error?) {
        let alertView = UIAlertController(title: "Service Error", message: "An Error occured while tring to communicate with the server. \(error?.localizedDescription ?? "")", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertView.addAction(okayAction)
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}
