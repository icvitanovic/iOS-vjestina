//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import CoreData

class QuizzesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var quizzes: [Quiz2]?
    
    var refreshControl: UIRefreshControl!
    let cellReuseIdentifier = String(describing: QuizTableViewCell.self) // TODO
    
    var fetchedResultsController: NSFetchedResultsController<Quiz2>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quizzes"
        setupTableView()
        setupData()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizzesViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    func setupData() {
//        DataController.shared.deleteAllData("Question2")
//        DataController.shared.deleteAllData("Quiz2")
        self.loadQuizzesFromCoreData()
        QuizService().fetchQuizzes(){ [weak self] (success) in
            if(success == true){
                do {
                    try self?.fetchedResultsController?.performFetch()
                    self?.refresh()
                } catch {
                    fatalError("Failed to fetch entities: \(error)")
                }
                
            }
        }
    }
    
    func loadQuizzesFromCoreData(){
        if let fetchedQuizzesResultController = DataController.shared.getQuizzesResultController(){
            fetchedQuizzesResultController.delegate = self
            self.fetchedResultsController = fetchedQuizzesResultController
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func quiz(atIndexPath indexPath: IndexPath) -> Quiz2? {
        guard let sections = self.fetchedResultsController?.sections else{
            return nil
        }
        let section = sections[indexPath.section]
        let quiz = section.objects?[indexPath.row] as! Quiz2
        return quiz
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
        var category = ""
        let view = QuizzesTableSectionHeader()
        if let sections = self.fetchedResultsController?.sections{
            let tableSection = sections[section]
            category = tableSection.name
        }
        view.setup(category: category)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quiz = quiz(atIndexPath: indexPath) {
            let singleQuizViewController = QuizViewController()
            singleQuizViewController.quiz = quiz
            navigationController?.pushViewController(singleQuizViewController, animated: true)
        }
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableViewCell
        
        if let quiz = self.quiz(atIndexPath: indexPath){
            cell.setup(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
//        if let quizSections = self.sections{
//            return quizSections.count
//        }
//        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return numberOfQuizzes()
//        if let quizSections = self.sections{
//            let section = quizSections[section]
//            return section.quizzes.count
//        }
//        return 0
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
}

extension QuizzesViewController: NSFetchedResultsControllerDelegate {
    
}
