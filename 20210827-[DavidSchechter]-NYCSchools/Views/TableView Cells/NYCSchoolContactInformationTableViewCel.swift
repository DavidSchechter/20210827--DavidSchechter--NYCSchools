//
//  NYCSchoolContactInformationTableViewCel.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit

class NYCSchoolContactInformationTableViewCel: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var website: UITextView!
    @IBOutlet weak var phoneNumber: UITextView!
    @IBOutlet weak var address: UILabel!
    
    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.website.textContainer.maximumNumberOfLines = 1
        self.website.textContainer.lineBreakMode = .byTruncatingTail
        self.phoneNumber.textContainer.maximumNumberOfLines = 1
        self.phoneNumber.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        self.website.text = model?.website
        self.phoneNumber.text = model?.phoneNumber
        self.address.text = model?.locationWithoutCoordinate()
    }
}
