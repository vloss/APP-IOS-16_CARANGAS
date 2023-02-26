//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Properties
    var car: Car!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            car = Car()
        }
        
        car.name = tfName.text!
        car.brand = tfBrand.text!
        if tfPrice.text!.isEmpty{
            tfPrice.text = "0"
        }
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex
        
        REST.save(car: car) { (success) in
            self.goBack()
        }
    }
    
    // MARK: - Methods
    func goBack(){

        DispatchQueue.main.async {
            // retorna para tela anterior
            self.navigationController?.popViewController(animated: true)
        }
    }
}
