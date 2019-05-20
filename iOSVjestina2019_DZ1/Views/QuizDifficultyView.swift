//
//  QuizDifficultyView.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import SnapKit

class QuizDifficultyView: UIView {
    
    var difficulty: Int
    var imageViews: [UIImageView]

    init(difficulty: Int,frame: CGRect) {
        self.difficulty = difficulty
        if(difficulty >  3){
            self.difficulty = 3
        }
        self.imageViews = []
        super.init(frame: frame)
        for i in 0...self.difficulty-1{
            let imageView: UIImageView = UIImageView()
            imageView.image = UIImage(named: "difficulty_star")
            self.addSubview(imageView)
            self.imageViews.append(imageView)
            if(i > 0){
                imageView.snp.makeConstraints({(make) -> Void in
                    make.width.height.equalTo(15)
                    make.centerY.equalTo(self)
                    make.left.equalTo(self.imageViews[i-1].snp.right).offset(2)
                })
            }
            else{
                imageView.snp.makeConstraints({(make) -> Void in
                    make.width.height.equalTo(15)
                    make.centerY.equalTo(self)
                    make.left.equalTo(self).offset(2)
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
