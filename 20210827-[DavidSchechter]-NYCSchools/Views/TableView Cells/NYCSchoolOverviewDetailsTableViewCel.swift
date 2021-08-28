//
//  NYCSchoolOverviewDetailsTableViewCel.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit

class NYCSchoolOverviewDetailsTableViewCel: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var overviewDetails: UILabel!

    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        self.overviewDetails.text = model?.overviewParagraph
    }
}
