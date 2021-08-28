//
//  NYCSchoolLocationTableViewCell.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit
import MapKit

class NYCSchoolLocationTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapImageView: UIImageView!
    
    //MARK: Private Paramters
    
    private var cachedImage: UIImage?
    
    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        if let cachedImage = cachedImage {
            mapImageView.image = cachedImage
        } else if let coordinate = model?.locationWithCoordinate() {
            let distanceInMeters: Double = 500
            
            let options = MKMapSnapshotter.Options()
            options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
            options.size = CGSize(width: self.frame.width, height: self.frame.width * 0.7)
            
            let bgQueue = DispatchQueue.global(qos: .background)
            let snapShotter = MKMapSnapshotter(options: options)
            mapImageView?.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            snapShotter.start(with: bgQueue, completionHandler: { [weak self] (snapshot, error) in
                guard error == nil else {
                    return
                }
                
                if let snapShotImage = snapshot?.image, let coordinatePoint = snapshot?.point(for: coordinate), let pinImage = UIImage(named: "pinImage") {
                    UIGraphicsBeginImageContextWithOptions(snapShotImage.size, true, snapShotImage.scale)
                    snapShotImage.draw(at: CGPoint.zero)
                    // need to fix the point position to match the anchor point of pin which is in middle bottom of the frame
                    let fixedPinPoint = CGPoint(x: coordinatePoint.x - pinImage.size.width / 2, y: coordinatePoint.y - pinImage.size.height)
                    pinImage.draw(at: fixedPinPoint)
                    let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                    self?.cachedImage = mapImage
                    DispatchQueue.main.async {
                        self?.mapImageView.image = mapImage
                        self?.mapImageView?.isHidden = false
                        self?.loadingIndicator.isHidden = true
                        self?.loadingIndicator.stopAnimating()
                    }
                    UIGraphicsEndImageContext()
                }
            })
        }
    }
}
