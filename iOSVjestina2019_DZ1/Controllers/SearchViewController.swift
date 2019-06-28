//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var quizzes: [Quiz2]?
    
    var refreshControl: UIRefreshControl!
    let cellReuseIdentifier = String(describing: QuizTableViewCell.self) // TODO
    
    var fetchedResultsController: NSFetchedResultsController<Quiz2>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.navigationItem.title = "Quiz search"
        
        self.searchInput.transform = CGAffineTransform(translationX: 0, y: -(self.searchInput.frame.origin.y + self.searchInput.frame.height))
        self.searchButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.searchButton.alpha = 0
        
        
        searchInput.delegate = self
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.transition(with: self.searchInput, duration: 0.4, options: .transitionFlipFromTop, animations: {
            self.searchInput.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
//            self.searchInput.transform = CGAffineTransform(translationX: 0, y: 0)
            self.searchButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.searchButton.alpha = 1
        }) { _ in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.searchInput.transform = CGAffineTransform(translationX: 0, y: -(self.searchInput.frame.origin.y + self.searchInput.frame.height))
            self.searchButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.searchButton.alpha = 0
        }, completion: {(finished:Bool) in
            super.viewWillDisappear(true)
        })
    }
    
    func setupTableView() {
        self.view.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        tableView.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizzesViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func searchInputEndingDidEnd(_ sender: UITextField) {
        search()
    }
    
    func setupData() {
        //        DataController.shared.deleteAllData("Question2")
        //        DataController.shared.deleteAllData("Quiz2")
//        self.loadQuizzesFromCoreData()
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

    @IBAction func searchButtonTapped(_ sender: Any) {
        search()
    }
    
    func search(){
        if let searchTerm = self.searchInput.text{
            if let fetchedResultsController = self.fetchedResultsController{
                do {
                    fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@ OR quizDescription CONTAINS[c] %@", searchTerm, searchTerm)
                    try fetchedResultsController.performFetch()
                    self.refresh()
                } catch {
                    fatalError("Failed to fetch entities: \(error)")
                }
            }
            else{
                if let fetchedQuizzesResultController = DataController.shared.getQuizzesResultController(withFilter: searchTerm){
                    fetchedQuizzesResultController.delegate = self
                    self.fetchedResultsController = fetchedQuizzesResultController
                    self.refresh()
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UITableViewDelegate {
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

extension SearchViewController: UITableViewDataSource {
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

extension SearchViewController: NSFetchedResultsControllerDelegate {
    
}
