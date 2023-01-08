//
//  NewsViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import UIKit
import Combine

protocol NewsPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func didTap(indexPath: IndexPath)
}

final class NewsViewController: UIViewController, NewsPresentable, NewsViewControllable {
    
    private var stories: [NewsData]?
    
    weak var listener: NewsPresentableListener?
    
    private(set) var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tv.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identfier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func update(with data: [NewsData]) {
        self.stories = data
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identfier, for: indexPath) as? NewsStoryTableViewCell,
            let stories = stories
        else { return UITableViewCell() }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier
        ) as? NewsHeaderView
        else { return nil }
        header.configure(with: .init(title: "Top Crypto News", shouldShowAddButton: false))
        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listener?.didTap(indexPath: indexPath)
    }
}
