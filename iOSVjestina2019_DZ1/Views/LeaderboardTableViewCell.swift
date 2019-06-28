//
//  LeaderboardTableViewCell.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {


    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameLabelDescription: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabelDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        rankLabel.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        usernameLabel.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        usernameLabelDescription.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        scoreLabel.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        scoreLabelDescription.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        rankLabel.textColor = UIColor.white
        usernameLabel.textColor = UIColor.white
        usernameLabelDescription.textColor = UIColor.white
        scoreLabel.textColor = UIColor.white
        scoreLabelDescription.textColor = UIColor.white
        
        rankLabel.snp.makeConstraints({(make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(5)
        })
        scoreLabel.snp.makeConstraints({(make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(60)
        })
        scoreLabelDescription.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(60)
        })
        usernameLabel.snp.makeConstraints({(make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(scoreLabel.snp.right).offset(40)
        })
        usernameLabelDescription.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(scoreLabel.snp.right).offset(40)
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rankLabel.text = ""
        self.usernameLabel.text = ""
        self.scoreLabel.text = ""
    }
    
    func setup(withLeaderBoardItem leaderBoardItem: LeaderBoardItem, withIndex index: Int) {
        self.rankLabel.text = String(index)
        self.usernameLabel.text = leaderBoardItem.username
        if let score = Double(leaderBoardItem.score){
            self.scoreLabel.text = "\(score.rounded(toPlaces: 2))"
        }
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
