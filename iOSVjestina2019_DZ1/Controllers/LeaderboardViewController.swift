//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var leaderBoardItems: [LeaderBoardItem]?
    var quizId: Int?
    
    var refreshControl: UIRefreshControl!
    let cellReuseIdentifier = String(describing: LeaderboardTableViewCell.self) // TODO
    
    init(quizId: Int32)
    {
        super.init(nibName: nil, bundle: nil)
        self.quizId = Int(quizId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LeaderboardViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    func setupData() {
        if let quizId = self.quizId{
            QuizService().fetchLeaderboard(quizId: quizId) { [weak self] (scores) in
                if var scores = scores{
                    scores = scores.sorted(by: { (x: LeaderBoardItem, y: LeaderBoardItem) -> Bool in
                        if let xscore = Double(x.score){
                            if let yscore = Double(y.score){
                                return xscore > yscore
                            }
                        }
                        return x.score > y.score
                    })
                    if(scores.count >= 20){
                        self?.leaderBoardItems = Array(scores.prefix(upTo: 20))
                    }
                    else{
                        self?.leaderBoardItems = scores
                    }
                    self?.refresh()
                }
            }
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }


    func leaderBoardItem(atIndex index: Int) -> LeaderBoardItem? {
        guard let leaderBoardItems = self.leaderBoardItems else {
            return nil
        }
        
        return leaderBoardItems[index]
    }
    
    func numberOfItems() -> Int {
        return self.leaderBoardItems?.count ?? 0
    }

}

extension LeaderboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LeaderboardTableViewCell
        
        if let leaderBoardItem = leaderBoardItem(atIndex: indexPath.row) {
            cell.setup(withLeaderBoardItem: leaderBoardItem, withIndex: indexPath.row + 1)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems()
    }
}
