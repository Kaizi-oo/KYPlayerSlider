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


    @IBOutlet weak var silder: KYPlayerSlider!

    @IBAction func changed() {
        guard let value1 = Float(textField1.text!) else {
            return
        }
        guard let value2 = Float(textField2.text!) else {
            return
        }

        silder.playValue = value1 / 100
        silder.bufferValue = value2 / 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

