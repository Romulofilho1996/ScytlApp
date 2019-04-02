//
//  UpdateDeleteSchedulePage.swift
//  ScytlAppDefinitivo
//
//  Created by Romulo de Vasconcelos Feijao Filho on 2019-02-20.
//  Copyright © 2019 ROME. All rights reserved.
//

import UIKit
import Alamofire

class UpdateDeleteSchedulePage: UIViewController {
    
    var titulo : String = ""
    var descricao : String = ""
    var completado : Bool = false
    var dataEnvio : String = ""
    var controleDeSegmento : Bool = false
    
    var datePicker = UIDatePicker()
    
    var newVariable = ViewController()
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var deadlineLabel: UITextField!
    
    @IBAction func IsCompleted(_ sender: UISegmentedControl) {
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
    
    @IBOutlet weak var isCompleted: UISegmentedControl!
    
    @IBAction func updateButton(_ sender: UIButton) {
        
        print("\(schedules[myIndex].Id)")
        
        let url = "http://prova.scytlbrasil.com:81/Api/tasks/EditTask?id=\(schedules[myIndex].Id)&userid=412c39876e8d48e6beb5c3e8e911d4"
        
        titulo = titleLabel.text!
        descricao = descriptionLabel.text!
        if(isCompleted.selectedSegmentIndex == 0){
            completado = true
        }else{
            completado = false
        }
        dataEnvio = deadlineLabel.text!
        
        
        let parameters = ["Title": "\(titulo)", "Description": "\(descricao)", "Completed" : "\(completado)", "Deadline" : "\(dataEnvio)"]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
        }
        
        let confirmationAlert = UIAlertController(title: "", message: "Schedule updated", preferredStyle: .alert)
        
        let confirmationAction = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.run(after: 1) {
                self.present(nextViewController, animated: true, completion: nil)
            }
            
        }
        
        
            confirmationAlert.addAction(confirmationAction)
        
        present(confirmationAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        titulo = titleLabel.text!
        descricao = descriptionLabel.text!
        if(isCompleted.selectedSegmentIndex == 0){
            completado = true
        }else{
            completado = false
        }
        dataEnvio = deadlineLabel.text!
        
        let alert = UIAlertController(title: "Are you sure?", message: "You are about to delete this schedule", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            let url = "http://prova.scytlbrasil.com:81/Api/tasks/RemoveTask?id=\(schedules[myIndex].Id)&userid=412c39876e8d48e6beb5c3e8e911d4"
            
            let parameters = ["Title": "\(self.titulo)", "Description": "\(self.descricao)", "Completed" : "\(self.completado)", "Deadline" : "\(self.dataEnvio)"]
            
            AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                print(response)
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.run(after: 1) {
                self.present(nextViewController, animated: true, completion: nil)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = schedules[myIndex].Title
        
        descriptionLabel.text = schedules[myIndex].Description
        
        if(schedules[myIndex].Completed == true){
            isCompleted.selectedSegmentIndex = 0
        }else{
            isCompleted.selectedSegmentIndex = 1
        }
        
        createToolbar()
        
        createAnotherToolbar()
        
        var ano = ""
        var mes = ""
        var dia = ""

        if(schedules[myIndex].Deadline != nil){
            ano = String(schedules[myIndex].Deadline.dropFirst(0).prefix(4) as Substring)
            mes = String(schedules[myIndex].Deadline.dropFirst(5).prefix(2) as Substring)
            dia = String(schedules[myIndex].Deadline.dropFirst(8).prefix(2) as Substring)
        }


        deadlineLabel.text = "\(mes)/\(dia)/\(ano)"
        
    }
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dateChanged))
        toolbar.setItems([done], animated: false)
        deadlineLabel.inputAccessoryView = toolbar
        deadlineLabel.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    func createAnotherToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.titleDescriptionChange))
        titleLabel.inputAccessoryView = toolbar
        descriptionLabel.inputAccessoryView = toolbar
        toolbar.setItems([done], animated: false)
    }
    
    @objc func dateChanged(){
        
        let dateFormatter = DateFormatter()
        
        print(datePicker.date)
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        deadlineLabel.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
    
    @objc func titleDescriptionChange(){
        self.view.endEditing(true)
    }


}
