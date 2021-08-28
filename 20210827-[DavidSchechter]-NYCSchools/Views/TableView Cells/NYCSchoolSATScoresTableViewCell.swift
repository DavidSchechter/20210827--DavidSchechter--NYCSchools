//
//  NYCSchoolSATScoresTableViewCell.swift
//  20210827-[DavidSchechter]-NYCSchools
//
//  Created by David Schechter on 8/27/21.
//

import UIKit

class NYCSchoolSATScoresTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var readingAvgStackView: UIStackView!
    @IBOutlet weak var readingAvg: UILabel!
    @IBOutlet weak var mathAvgStackView: UIStackView!
    @IBOutlet weak var mathAvg: UILabel!
    @IBOutlet weak var writingAvgStackView: UIStackView!
    @IBOutlet weak var writingAvg: UILabel!
    
    //MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: Configure Methods
    
    func configureWithModel(_ model: NYCHighSchool?) {
        self.schoolName.text = model?.schoolName
        if let satCriticalReadingAvgScore = model?.satCriticalReadingAvgScore {
            self.readingAvg.text = satCriticalReadingAvgScore
            self.readingAvgStackView.isHidden = false
        } else {
            self.readingAvgStackView.isHidden = true
        }
        if let satMathAvgScore = model?.satMathAvgScore {
            self.readingAvg.text = satMathAvgScore
            self.mathAvgStackView.isHidden = false
        } else {
            self.mathAvgStackView.isHidden = true
        }
        if let satWritinAvgScore = model?.satWritinAvgScore {
            self.readingAvg.text = satWritinAvgScore
            self.writingAvgStackView.isHidden = false
        } else {
            self.writingAvgStackView.isHidden = true
        }
    }
}
