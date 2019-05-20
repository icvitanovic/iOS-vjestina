//
//  QuizTableViewCell.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var quizDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        title.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        quizDescription.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        title.textColor = UIColor.white
        quizDescription.textColor = UIColor.white
        quizImage.snp.makeConstraints({(make) -> Void in
            make.width.height.equalTo(100)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(5)
        })
        quizDescription.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        quizDescription.text = ""
    }
    
    func setup(withQuiz quiz: Quiz) {
        self.title.text = quiz.title
        self.quizDescription.text = quiz.description
        let urlString = quiz.imageUrl
        if let url = URL(string: urlString){
            quizImage.kf.setImage(with: url)
        }
        let difficultyView: QuizDifficultyView = QuizDifficultyView(difficulty: quiz.level, frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        difficultyView.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        self.addSubview(difficultyView)
        difficultyView.snp.makeConstraints({(make) -> Void in
            make.height.equalTo(22)
            make.width.equalTo(53)
            make.top.equalTo(quizImage.snp.top)
            make.right.equalTo(self).inset(5)
        })
        title.snp.makeConstraints({(make) -> Void in
            make.height.equalTo(22)
            make.top.equalTo(quizImage.snp.top)
            make.left.equalTo(quizImage.snp.right).offset(5)
            make.right.equalTo(difficultyView.snp.left).inset(10)
        })
        quizDescription.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(quizImage.snp.right).offset(5)
            make.right.equalTo(difficultyView.snp.left).inset(10)
        })
    }
    
}
