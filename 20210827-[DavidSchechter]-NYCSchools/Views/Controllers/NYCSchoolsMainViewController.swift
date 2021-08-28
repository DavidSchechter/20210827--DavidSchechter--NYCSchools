//
//  NYCSchoolsMainViewController.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit
import Combine

class NYCSchoolsMainViewController: UIViewController {

    //MARK: IBOutlet
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Public Paramters
    
    let viewModel: NYCSchoolsViewModelProtocol = NYCSchoolsViewModel(dataManager: DataManager())
    
    //MARK: Private Paramters
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()
    private var currectData: [NYCHighSchool] = [NYCHighSchool]()
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchController()
        bindViewModel()
        
        tableView.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        viewModel.getData()
    }
    
    // MARK: Helper Methods
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Name"
        searchController.searchBar.tintColor = UIColor.black
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        viewModel.modelPublisher
            .sink { [weak self] schools in
                self?.currectData = schools
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                self?.loadingIndicator.isHidden = true
                self?.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.filteredPublisher
            .sink(receiveValue: { [weak self] schools in
                if let schools = schools {
                    self?.currectData = schools
                    self?.tableView.reloadData()
                }
            })
            .store(in: &cancellables)
        
        viewModel.titlePublisher
            .sink(receiveValue: { [weak self] title in
                self?.title = title
            })
            .store(in: &cancellables)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSchoolDetails" {
            let highSchoolWithSATScoreVC = segue.destination as! NYCSchoolDetailsViewController
            if let school = sender as? NYCHighSchool {
                highSchoolWithSATScoreVC.currectData = school
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension NYCSchoolsMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currectData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NYCSchoolOverviewTableViewCell") as! NYCSchoolOverviewTableViewCell
        cell.configureWithModel(currectData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NYCSchoolsMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowSchoolDetails", sender: currectData[indexPath.row])
    }
}

// MARK: - UISearchResultsUpdating
extension NYCSchoolsMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterByName(searchController.searchBar.text)
    }
}

