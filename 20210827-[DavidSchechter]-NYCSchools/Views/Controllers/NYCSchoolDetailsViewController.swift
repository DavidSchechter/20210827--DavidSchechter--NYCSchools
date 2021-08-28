//
//  NYCSchoolDetailsViewController.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit

class NYCSchoolDetailsViewController: UIViewController {

    var currectData: NYCHighSchool = NYCHighSchool()
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currectData.schoolName ?? ""
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NYCSchoolDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NYCSchoolSATScoresTableViewCell") as! NYCSchoolSATScoresTableViewCell
            cell.configureWithModel(currectData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NYCSchoolOverviewDetailsTableViewCel") as! NYCSchoolOverviewDetailsTableViewCel
            cell.configureWithModel(currectData)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NYCSchoolContactInformationTableViewCel") as! NYCSchoolContactInformationTableViewCel
            cell.configureWithModel(currectData)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NYCSchoolLocationTableViewCell") as! NYCSchoolLocationTableViewCell
            cell.configureWithModel(currectData)
            return cell
        }
    }
}
