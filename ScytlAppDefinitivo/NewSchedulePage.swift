//
//  NewSchedulePage.swift
//  ScytlAppDefinitivo
//
//  Created by Romulo de Vasconcelos Feijao Filho on 2019-02-14.
//  Copyright © 2019 ROME. All rights reserved.
//

import UIKit
import Alamofire

class NewSchedulePage: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var dateText: UITextField!
    
    let whiteColor = UIColor.white
    let greyColor = UIColor.init(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    
    var datePicker = UIDatePicker()
    
    var titulo : String = ""
    var descricao : String = ""
    var completado : Bool = false
    var dataEnvio : String = ""
    var controleDeSegmento : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        titleText.layer.cornerRadius = 10.0
        titleText.layer.borderWidth = 0.5
        titleText.layer.borderColor = greyColor.cgColor
        titleText.placeholder = "  Title"
        titleText.layer.backgroundColor = whiteColor.cgColor
        
        descriptionText.text = "Description"
        descriptionText.layer.cornerRadius = 10.0
        descriptionText.layer.borderWidth = 0.5
        descriptionText.layer.borderColor = greyColor.cgColor
        descriptionText.layer.backgroundColor = whiteColor.cgColor
        
        dateText.placeholder = "  Deadline"
        dateText.layer.cornerRadius = 10.0
        dateText.layer.borderWidth = 0.5
        dateText.layer.borderColor = greyColor.cgColor
        dateText.layer.backgroundColor = whiteColor.cgColor
        
        createToolbar()
        
        createAnotherToolbar()

    }
    
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer) {
        descriptionText.text = ""
    }
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dateChanged))
        toolbar.setItems([done], animated: false)
        dateText.inputAccessoryView = toolbar
        dateText.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    @objc func dateChanged(){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
    
    func createAnotherToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.titleDescriptionChange))
        titleText.inputAccessoryView = toolbar
        descriptionText.inputAccessoryView = toolbar
        toolbar.setItems([done], animated: false)
    }
    
    @objc func titleDescriptionChange(){
        self.view.endEditing(true)
    }

    
    @IBAction func completedSchedule(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            controleDeSegmento = true
        }else if(sender.selectedSegmentIndex == 1){
            controleDeSegmento = false
        }
        
    }
    
    func run(after seconds: Int, completion: @escaping() -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
        
    }
    
    @IBAction func createSchedule(_ sender: UIButton) {
        
        let confirmationAlert = UIAlertController(title: "", message: "Schedule created", preferredStyle: .alert)
        
        let confirmationAction = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.run(after: 1) {
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
        
        confirmationAlert.addAction(confirmationAction)
        
        
        
        titulo = titleText.text!
        descricao = descriptionText.text
        completado = controleDeSegmento
        dataEnvio = dateText.text!
        
        print(dataEnvio as Any)
        
        let parameters = ["Title": "\(titulo)", "Description": "\(descricao)", "Completed" : "\(completado)", "Deadline" : "\(dataEnvio)", "UserId" : "412c39876e8d48e6beb5c3e8e911d4"]
        
        let url = "http://prova.scytlbrasil.com:81/Api/tasks/PostTask?userid=412c39876e8d48e6beb5c3e8e911d4"// This will be your link
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
        }
        
        self.present(confirmationAlert, animated: true, completion: nil)
        
    }

}
