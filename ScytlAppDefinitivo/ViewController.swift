//
//  ViewController.swift
//  ScytlAppDefinitivo
//
//  Created by Romulo de Vasconcelos Feijao Filho on 2019-02-14.
//  Copyright © 2019 ROME. All rights reserved.
//

import UIKit

struct Schedule: Decodable, Encodable{
    var Title : String?
    var Description : String!
    var Completed : Bool!
    var Deadline : String!
    var Id : Int
}

var myIndex = 0

var schedules = [Schedule]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBAction func refreshData(_ sender: UIButton) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func run(after seconds: Int, completion: @escaping() -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
        
    }
    
    var index = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        gatherData()

        run(after:1){
            self.tableView.reloadData()
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSchedule", for: indexPath)
        let schedule = schedules[indexPath.row]
        if(schedule.Title != nil){
            cell.textLabel?.text = "\(indexPath.row + 1). \(schedule.Title!)"
        }else{
            cell.textLabel?.text = "\(indexPath.row + 1)."
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
        print(schedules[indexPath.row])
    }
    
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
    
    func gatherData(){
        
        let jsonURL = "http://prova.scytlbrasil.com:81/Api/tasks?userid=412c39876e8d48e6beb5c3e8e911d4"
        
        guard let url = URL(string: jsonURL) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { (data, response, err) in
            guard let data = data else{return}
            
            do{
                schedules = try JSONDecoder().decode([Schedule].self, from: data)
            }catch let jsonErr{
                print("Error serializing json: ", jsonErr)
            }
            
        }.resume()

    }


}

