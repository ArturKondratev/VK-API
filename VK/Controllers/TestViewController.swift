//
//  TestViewController.swift
//  VK
//
//  Created by Артур Кондратьев on 13.12.2021.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var testView: TestView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.setImage(UIImage(named: "2"))
      
    }
}

