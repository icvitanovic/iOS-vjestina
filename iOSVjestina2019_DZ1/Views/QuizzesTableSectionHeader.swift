//
//  QuizzesTableSectionHeader.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class QuizzesTableSectionHeader: UIView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(category: String){
//        backgroundColor = UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0)
        backgroundColor = QuizCategoryColor(rawValue: category)?.value
        titleLabel = UILabel()
        titleLabel.text = category
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(self).offset(16)
            make.centerX.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
