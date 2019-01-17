//
//  ViewController.swift
//  Weather App
//
//  Created by Ramu on 1/6/19.
//  Copyright © 2019 Ramu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    var imageurl: String!
    var degree: Double!
    var condition: String!
    var city: String!
    
    var exists: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=9e55b5f309844eda985231607190501&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        _ = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    if let current = json["current"] as? [String: AnyObject] {
                        if let temp = current["temp_f"] as? Double {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String: AnyObject] {
                            self.condition = (condition["text"] as! String)
                            let icon = condition["icon"] as! String
                            self.imageurl = "http:\(icon)"
                        }
                    }
                    if let location = json["location"] as? [String: AnyObject] {
                        self.city = (location["name"] as! String)
                    }
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    DispatchQueue.main.async {
                        if self.exists{
                            self.degreeLabel.isHidden = false
                            self.cityLabel.isHidden = false
                            self.imageview.isHidden = false
                            self.conditionLabel.isHidden = false
                            self.degreeLabel.text = "\(self.degree.description)°F"
                            self.cityLabel.text = self.city
                            self.conditionLabel.text = self.condition
                            if self.conditionLabel.text == "Cloudy" || self.conditionLabel.text == "Partly cloudy" {
                                self.setBackground(condition: BackgroundView.cloudy) }
                                else if self.conditionLabel.text == "Mist" {
                                self.setBackground(condition: BackgroundView.mist) }
                                else if self.conditionLabel.text == "Rainy" || self.conditionLabel.text == "Light rain" {
                                self.setBackground(condition: BackgroundView.rainy) }
                                else if self.conditionLabel.text == "Sunny" {
                                self.setBackground(condition: BackgroundView.sunny) }
                                else if self.conditionLabel.text == "Clear" {
                                self.setBackground(condition: BackgroundView.clear) }
                                else if self.conditionLabel.text == "Overcast" {
                                self.setBackground(condition: BackgroundView.overcast)
                            }
                                }
                                    
                        
                            
           
                         else {
                            self.degreeLabel.isHidden = true
                            self.cityLabel.isHidden = false
                            self.imageview.isHidden = true
                            self.cityLabel.text = "No matching city found"
                            self.exists = true
                        }
                    }
                } catch let jsonError {
                    print(jsonError.localizedDescription)
            }
        }
    }.resume()
}
    func setBackground(condition: BackgroundView) {
        switch condition {
        case .rainy:
            self.backgroundImage.image = UIImage.init(named: "rainy")
        case .cloudy:
           self.backgroundImage.image = UIImage.init(named: "cloudy2")
        case .snow:
           self.backgroundImage.image = UIImage.init(named: "snowy")
        case .sunny:
           self.backgroundImage.image = UIImage.init(named: "sunny")
        case .mist:
            self.backgroundImage.image = UIImage.init(named: "mist")
        case .clear:
            self.backgroundImage.image = UIImage.init(named: "clear")
        case .overcast:
            self.backgroundImage.image = UIImage.init(named: "Overcast")
        default:
           self.backgroundImage.image = UIImage.init(named: "weatherforecast")
        }
}
}

extension UIImageView {
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)

        _ = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        .resume()
    }
}

