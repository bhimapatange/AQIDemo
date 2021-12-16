//
//  AQIDetailsVC.swift
//  AQIDemoProject
//
//  Created by Mayur on 15/12/21.
//

import UIKit
import Charts
class AQIDetailsVC: UIViewController {
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var lblAqiValue: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    let detailsViewModel : AqiDetailsViewModel!
//    var graphData = [Double:Double]()
    var graphValueArray : [Double] = []
    
    // MARK: - Init
    init?(aqiModel: AQIModel, coder: NSCoder) {
      self.detailsViewModel = AqiDetailsViewModel(aqiModel: aqiModel)
      super.init(coder: coder)
    }

    @available(*, unavailable, renamed: "init(aqiModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("use init(aqiModel:coder:)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        startFetchingAQI()
    }
    override func viewWillDisappear(_ animated: Bool) {
      stopFetchingAQI()
    }
    
    func setupData() {
        lblCity.text = detailsViewModel.getAqiModel().city
        lblAqiValue.text =  detailsViewModel.getAqiModel().aqiValue
        viewInfo.backgroundColor = detailsViewModel.getAqiModel().aqiType.color
        lblQuality.text = "Quality : " + detailsViewModel.getAqiModel().aqiType.title
        lblNotes.text = "Health Tips : " + detailsViewModel.getAqiModel().aqiType.notes
    }
    private func startFetchingAQI() {
        detailsViewModel.openSocket()
        fetchAQI()
    }
    private func fetchAQI() {
      print("details 1")
        detailsViewModel.refreshList(after: API.timeInterval) { [weak self] in
        print("details 2")
        DispatchQueue.main.async {
          print("details 3")
            if let aqi = self?.detailsViewModel.getAqiModel() {
                self?.graphValueArray.append(aqi.aqi)
                 self?.updateGraph()
                self?.setupData()
            }
        }
      }
    }
    private func stopFetchingAQI() {
        detailsViewModel.closeSocket()
        detailsViewModel.stopFetchingData()
    }
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]()
//
//        let t = Date().timeIntervalSince(Date())
       
        for (index, _) in self.graphValueArray.enumerated(){
            let value = ChartDataEntry(x:Double(index) , y: graphValueArray[index]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        // hide grid lines
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.enabled = false
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "AQI per 10 seconds") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.black] //Sets the colour to blue
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        lineChartView.data = data //finally - it adds the chart data to the chart and causes an
    
        lineChartView.chartDescription?.text = "Realtime AQI for city: \(self.detailsViewModel.getAqiModel().city)" // Here we set the description for the graph
        lineChartView.xAxis.valueFormatter = XAxisNameFormater(count: self.graphValueArray.count-1)
        
        lineChartView.xAxis.granularityEnabled = false
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
    }
}

// formatter clas for xaxis labels
final class XAxisNameFormater: NSObject, IAxisValueFormatter {
    var totalCount = 0
    init(count : Int) {
        self.totalCount = count
    }
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let valueToShow = (self.totalCount - Int(value))*10
        if self.totalCount > 5 {
            if (valueToShow == 0)
            {
                return "now"
            }else {
                return "\(valueToShow)"
            }
        }else {
            if (valueToShow == 0)
            {
                return "Just now"
            }else {
                return "\(valueToShow) sec ago"
            }
        }
        
    }
    
}
