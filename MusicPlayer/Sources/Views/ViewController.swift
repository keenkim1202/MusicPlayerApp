//
//  ViewController.swift
//  MusicPlayer
//
//  Created by KEEN on 2021/04/23.
//

import UIKit

class ViewController: UIViewController {
  // MARK: Properties
  let album = Album.get()
  
  private lazy var tableView: UITableView = {
    let v = UITableView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.delegate = self
    v.dataSource = self
    v.register(AlbumTableViewCell.self, forCellReuseIdentifier: "cell")
    v.estimatedRowHeight = 110
    v.rowHeight = UITableView.automaticDimension
    v.tableFooterView = UIView()
    return v
  }()
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  private func setupView() {
    self.title = "My Music Player"
    view.addSubview(tableView)
    
    setupConstraints()
  }
  
  // MARK: Configure
  func setupConstraints() {
    // UITableView
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return album.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
    cell.album = album[indexPath.row]
    return cell
  }
}
