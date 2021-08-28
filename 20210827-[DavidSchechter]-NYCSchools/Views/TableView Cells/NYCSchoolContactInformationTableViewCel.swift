//
//  NYCSchoolContactInformationTableViewCel.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit

class NYCSchoolContactInformationTableViewCel: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    
    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        self.website.text = model?.website
        self.phoneNumber.text = model?.phoneNumber
        self.address.text = model?.locationWithoutCoordinate()
    }
}
