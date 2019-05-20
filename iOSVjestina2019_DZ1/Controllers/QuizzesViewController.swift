//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class QuizzesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var quizzes: [Quiz]?
    
    var refreshControl: UIRefreshControl!
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupTableView()
        setupData()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizzesViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    func setupData() {
        QuizService().fetchQuizzes(){ [weak self] (quizzes) in
            self?.quizzes = quizzes
            self?.refresh()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func quiz(atIndex index: Int) -> Quiz? {
        guard let quizzes = quizzes else {
            return nil
        }
        
        return quizzes[index]
    }
    
    func numberOfQuizzes() -> Int {
        return quizzes?.count ?? 0
    }

}

extension QuizzesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = QuizzesTableSectionHeader()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quiz = quiz(atIndex: indexPath.row) {
            let singleQuizViewController = QuizViewController()
            singleQuizViewController.quiz = quiz
            navigationController?.pushViewController(singleQuizViewController, animated: true)
        }
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableViewCell
        
        if let quiz = quiz(atIndex: indexPath.row) {
            cell.setup(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuizzes()
    }
}
