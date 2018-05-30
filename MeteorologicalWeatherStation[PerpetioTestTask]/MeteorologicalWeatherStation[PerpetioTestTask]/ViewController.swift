//
//  ViewController.swift
//  MeteorologicalWeatherStation[PerpetioTestTask]
//
//  Created by Orest on 30.05.2018.
//  Copyright © 2018 Orest Patlyka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    private let reuseIdentifier = "mainVCCell"
    var locationsArr = ["Yeovilton", "Bradford", "Whitby", "Waddington"]

    var weatherStr = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsArr.sort()
        
        loadWeatherData()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArr.count
    }
    
    // MARK: - Cells creation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = locationsArr[indexPath.row]
        
        return cell
    }
    
    // MARK: - Methods
    
    func parseWeatherStr(_ str: String) -> (locationDescription: String, weatherInfoArr: [String]) {
        var description = ""
        var weatherInfoArr = [String]()
        
        var strArr = str.components(separatedBy: "yyyy")
        description = strArr[0]
        
        strArr = str.components(separatedBy: "hours")
        if strArr.count > 1 {
            weatherInfoArr = strArr[1].components(separatedBy: "\r\n")
        }
        
        return (description, weatherInfoArr)
    }
    
    func loadWeatherData() {
        let weatherUrlString = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/bradforddata.txt"
        guard let weatherUrl = URL(string: weatherUrlString) else { return }
        
        URLSession.shared.downloadTask(with: weatherUrl) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                self.weatherStr = try String(contentsOf: data, encoding: String.Encoding.utf8)
                print(self.weatherStr)
            } catch let downloadErr{
                print(downloadErr.localizedDescription)
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        
        let tuple = parseWeatherStr(weatherStr)
        
        detailVC.weatherInfoArr = tuple.weatherInfoArr
    }
}

