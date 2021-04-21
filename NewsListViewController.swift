//
//  ViewController.swift
//  OleksiyNewsAPI
//
//  Created by Oleksa-Mykhaylo Boyko on 01.04.2021.
//

import UIKit

class NewsListViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var articles: [Article] = []
    public var params: [QueryParameter] = []
    
    // MARK: - Private Properties
    
    private let cellId = "TableViewCell"
    private let toSegue = "filterSegue"
    private var refreshControl: UIRefreshControl?
    private var limit = 1
    private var word: QueryParameter?
    private var country: QueryParameter?
    private var source: QueryParameter?
    private var category: QueryParameter?
    private var getIndex = 0
    private var sizeOfArticlPagin: Int?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ifilterButton: UIBarButtonItem!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticlesPag()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        addRefreshControl()
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButton(_ sender: UIButton) {
        if(searchField.text! == "") {
            return
        } else if (searchField.text! == "Search") {
            paramsButtonChange()
        } else {
            params.removeAll()
            country = nil
            source = nil
            category = nil
            paramsButtonChange()
        }
        searchField.text! = " "
    }
    
    // MARK: - Private functions
    
        func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView() {
        refreshControl?.endRefreshing()
        self.limit = 1
        self.getIndex = 0
        articles.removeAll()
        getArticlesPag()
        tableView.reloadData()
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource, NewsListViewControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TableViewCell
        cell!.selectionStyle = .none
        let article = articles[indexPath.row]
        cell!.setUp(article: article)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        performSegue(withIdentifier: "viewWeb", sender: article)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count - 1 {
            self.limit += 1
            if self.limit < self.sizeOfArticlPagin! {
                getArticlesPag()
            }
        }
    }
        
    func getArticlesPag () {
        NetworkService.shared.getArticles(params: params, completion: { (articles, error) in
            self.sizeOfArticlPagin = articles?.count
            if error == nil {
                if let articles = articles {
                    while self.getIndex < self.limit {
                        self.articles.append(articles[self.getIndex])
                        self.getIndex += 1
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func paramsButtonChange() {
        self.limit = 1
        self.getIndex = 0
        self.articles.removeAll()
        self.word = QueryParameter(key: "q", value: searchField.text!)
        params = [self.word!]
        if let category = category {
            self.params.remove(at: 0)
            self.params.append(country!)
            self.params.append(source!)
            self.params.append(category)
        }
        getArticlesPag()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toSegue {
            if let selectVC = segue.destination as? FiltersTableViewController {
                selectVC.newsListViewControllerDelegate = self
            }
        } else if let articleReviewVC = segue.destination as? ArticleReviewViewController {
            articleReviewVC.url1 = (sender as? Article)?.url  ?? ""
        }
    }
    
    func infoWasDelegated(selectedCo: String, selectedSo: String, selectedCate: String) {
        self.country = QueryParameter(key: "country", value: selectedCo)
        self.source = QueryParameter(key: "source", value: selectedSo)
        self.category = QueryParameter(key: "category", value: selectedCate)
        searchField.text! = "Search"
    }
}

protocol NewsListViewControllerDelegate {
    func infoWasDelegated(selectedCo: String, selectedSo: String, selectedCate: String )
}
