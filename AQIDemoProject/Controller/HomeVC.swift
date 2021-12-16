//
//  AQICitiesVC.swift
//  AQIDemoProject
//
//  Created by Mayur on 01/12/21.
//

import UIKit

class HomeVC: UIViewController {

    
    let homeViewModel = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
    
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
      stopFetchingAQI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      startFetchingAQI()
    }
   
    private func setupView() {
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableView.automaticDimension
      self.tableView.tableFooterView = UIView()
    }
   
    
    
    private func fetchAQI() {
      print("fetchAQI 1")
        homeViewModel.refreshList(after: API.timeInterval) { [weak self] in
        print("fetchAQI 2")
        DispatchQueue.main.async {
          print("fetchAQI 3")
          self?.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
        }
      }
    }
    
    private func navigateToDetailsPage(_ indexPath: IndexPath) {
      guard let model = homeViewModel.getAQIModel(index: indexPath.row) else {
        return
      }
      guard let viewController = storyboard?.instantiateViewController(
        identifier: "AQIDetailsVC",
        creator: { coder in
          AQIDetailsVC(aqiModel: model, coder: coder)
        }
      ) else {
        fatalError("Failed to create Details VC")
      }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func startFetchingAQI() {
      homeViewModel.openSocket()
      fetchAQI()
    }
    
    private func stopFetchingAQI() {
      homeViewModel.closeSocket()
      homeViewModel.stopFetchingData()
    }
    
  }


  // MARK: - UITableViewDataSource
  extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return homeViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "AQITableCell",
        for: indexPath
      ) as! AQITableCell
      
      //configure
      if let model = homeViewModel.getAQIModel(index: indexPath.row) {
        cell.setupData(model)
      }
          
      return cell
    }
  }

  // MARK: - UITableViewDelegate
  extension HomeVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      navigateToDetailsPage(indexPath)
    }
}
