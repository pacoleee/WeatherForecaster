//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Paco Lee on 2016-05-04.
//  Copyright © 2016 Paco Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var cityInput: UITextField!
    
    @IBOutlet var displayWeather: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findWeather(sender: AnyObject) {
        let url = NSURL(string:"http://www.weather-forecast.com/locations/" + cityInput.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            var weather = ""
            var urlError = false
            
            if error == nil {
                let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
            
                var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                
                if urlContentArray.count > 1 {
                    let weatherString = urlContentArray[1]
                    var weatherArray = weatherString.componentsSeparatedByString("</span>")
                    weather = weatherArray[0] as String
                    
                    weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                } else {
                    urlError = true
                }
                
            } else {
                urlError = true
            }
            
            dispatch_async(dispatch_get_main_queue()) {
            
                if urlError == true {
                    self.displayWeather.text = "Was not able to find weather for \"" + self.cityInput.text! + "\". Please try again."
                } else {
                    self.displayWeather.text = weather
                }
            }
            
        }
        
        task.resume()
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityInput.resignFirstResponder()
        return true;
    }

}

