//
//  NYCSchoolOverviewTableViewCell.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class NYCSchoolOverviewTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolAddress: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    //MARK: Private Paramters
    
    private var currentModel: NYCHighSchool?
    
    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.callButton.layer.cornerRadius = 5
        self.navigateButton.layer.cornerRadius = 5
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        currentModel = nil
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        self.currentModel = model
        self.schoolName.text = model?.schoolName
        self.schoolAddress.text = model?.locationWithoutCoordinate()
        self.callButton.setTitle("Call: \(model?.phoneNumber ?? "")", for: .normal)
    }
    
    // MARK: IBActions
    
    @IBAction func callNumber(_ sender: Any) {
        if let url = URL(string: "tel://\(String(describing: currentModel?.phoneNumber ?? ""))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            let alertView = UIAlertController(title: "Error!", message: "Calls cannot be made from a Simulator. Please try a physical device to call - \(currentModel?.phoneNumber ?? "")", preferredStyle: .alert)
            
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
    
    @IBAction func navigateToAddress(_ sender: Any) {
        if let highSchoolCoordinate = currentModel?.locationWithCoordinate() {
            let coordinate = CLLocationCoordinate2DMake(highSchoolCoordinate.latitude, highSchoolCoordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "\(currentModel?.schoolName ?? "")"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
