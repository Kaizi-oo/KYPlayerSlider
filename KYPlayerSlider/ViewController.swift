//
//  ViewController.swift
//  KYPlayerSlider
//
//  Created by kyang on 2018/9/4.
//  Copyright © 2018年 chinaxueqian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!


    @IBOutlet weak var bufferSlider: UISlider!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var bufferLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!

    @IBOutlet weak var silder: KYPlayerSlider!

    @IBAction func bufferSliderChanged(_ sender: UISlider) {
        silder.bufferValue = sender.value

    }
    @IBAction func playSliderChanged(_ sender: UISlider) {
        silder.playValue = sender.value
    }

    @IBAction func playerSliderChanged(_ sender: KYPlayerSlider) {

        self.bufferSlider.value = sender.bufferValue
        self.playSlider.value = sender.playValue
    }


    @IBAction func changed() {
        guard let value1 = Float(textField1.text!) else {
            return
        }
        guard let value2 = Float(textField2.text!) else {
            return
        }
        silder.minimumValue = value1
        silder.maximumValue = value2

        self.bufferSlider.minimumValue = value1
        self.bufferSlider.maximumValue = value2
        self.playSlider.minimumValue = value1
        self.playSlider.maximumValue = value2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.textField1.text = "\(silder.minimumValue)"
        self.textField2.text = "\(silder.maximumValue)"

        self.playSlider.minimumValue = silder.minimumValue
        self.playSlider.maximumValue = silder.maximumValue
        self.bufferSlider.minimumValue = silder.minimumValue
        self.bufferSlider.maximumValue = silder.maximumValue

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

