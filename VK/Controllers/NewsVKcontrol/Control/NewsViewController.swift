//
//  NewsViewController.swift
//  VK
//
//  Created by Артур Кондратьев on 16.05.2022.
//

import Foundation
import UIKit
import Kingfisher

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars
    private var refrControl = UIRefreshControl()
    private let vkService = VKnewsService()
    private var newsList = NewsList(news: [], next_from: "")
    private var nextFrom = ""
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register( UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCellID")
        self.loadNews()
        self.setupRefreshControl()
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellID", for: indexPath)
        cell.selectionStyle = .none
        let new = newsList.news[indexPath.row]
        (cell as? NewsCell)?.configure(new: new)
        
        return cell
    }
    
    
    //MARK: - Load next news - Infinite Scrolling
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        DispatchQueue.global().async {
            let percent = Double(indexPath.row) / Double(self.newsList.news.count)
            if percent >= 0.9 {
                self.vkService.loadNews (start_from: self.nextFrom, start_time: nil ) { [weak self] news, error in
                    guard error == nil else {
                        print("error refresh news")
                        return
                    }
                    self?.nextFrom = news?.next_from ?? ""
                    self?.newsList.news.append(contentsOf: news?.news ?? [])
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Load news
    private func loadNews() {
        
        vkService.loadNews (start_from: "", start_time: nil) { [weak self] news, error in
            guard error == nil else {
                print("Some error in loading")
                return
            }
            self?.nextFrom = news?.next_from ?? ""
            self?.newsList = news!
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Refresh News - Pull-to-refresh
    private func setupRefreshControl() {
        refrControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refrControl.tintColor = .systemBlue
        refrControl.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        tableView.refreshControl = refrControl
    }
    
    @objc
    private func refreshNews(_ sender: UIRefreshControl) {
        defer { sender.endRefreshing()}
        
        vkService.loadNews (start_from: "", start_time: nil) { [weak self] news, error in
            guard error == nil else {
                print("Some error in loading")
                return
            }
            self?.nextFrom = news?.next_from ?? ""
            self?.newsList = news!
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        //        let mostFreshNewsDate = self.newsList.news.first?.item.date ?? Date().timeIntervalSince1970
        //        vkService.loadNews (start_from: "", start_time: mostFreshNewsDate + 1) { [weak self] news, error  in
        //
        //            guard error == nil else {
        //                print("Some error in loading")
        //                return
        //            }
        //            guard (news?.news.count)! > 0 else { return }
        //            self?.newsList.news.insert(contentsOf: news?.news ?? [], at: 0)
        //            let indexSet = IndexSet(integersIn: 1..<(news?.news.count)! )
        //            self!.tableView.insertSections(indexSet, with: .automatic)
        //        }
        
    }
}



