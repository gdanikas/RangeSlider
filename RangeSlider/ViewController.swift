//
//  ViewController.swift
//  RangeSlider
//
//  Created by George Danikas on 9/21/15.
//  Copyright © 2015 Intelen Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RangeSliderDelegate {

    @IBOutlet weak var rangeSliderContainter: UIView!
    @IBOutlet weak var maxIndicatorValueLbl: UILabel!
    @IBOutlet weak var minIndicatorValueLbl: UILabel!
    @IBOutlet weak var upperValueLbl: UILabel!
    @IBOutlet weak var lowerValueLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSliderContainter.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize slider and add it to view
        let slider = RangeSlider(frame:rangeSliderContainter.bounds)
        slider.backgroundColor = UIColor.clearColor()
        slider.delegate = self
        slider.minValue = -20.0
        slider.maxValue = 50.0
        slider.upperValue = 28.0
        slider.lowerValue = 14.0
        
        // Add slider to container view
        rangeSliderContainter.addSubview(slider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Range Slider Delagate
    func didUpperValueChanged(value: CGFloat) {
        upperValueLbl.text = "\(Int(value))\u{00B0}C"
    }

    func didLowerValueChanged(value: CGFloat) {
        lowerValueLbl.text = "\(Int(value))\u{00B0}C"
    }

}

