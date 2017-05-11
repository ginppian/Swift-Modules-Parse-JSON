//
//  ViewController.swift
//  REST
//
//  Created by ginppian on 10/05/17.
//  Copyright © 2017 Nut Systems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

class ViewController: UIViewController {
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
        ]
    
    let params : Parameters = ["token": "c31e7cc5503e222a6d2ab594c845730272273a5bdcdbd1b97e29df7e19b3ecdadf021fe6a05a0da5c7046e670d89365181d15d037262822231735da484398578"]
    
    let url = "https://offercity.herokuapp.com/api/mostrarEstablecimiento"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            Alamofire.request(self.url, method: .post, parameters: self.params, encoding: URLEncoding.httpBody, headers: self.headers)
                
                .responseString(completionHandler: { response in
                })
                .responseObject { (response: DataResponse<Edoardo>) in
                    
                    let edoardo = response.result.value
                    print(edoardo?.arrayRes ?? "valio barriga")
                    
                    if let restaurantes = edoardo?.arrayRes {
                        for restaurante in restaurantes {
                            print(restaurante.nombre)
                        }
                    }
                    
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                
                self.activity.startAnimating()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Edoardo: Mappable {
    
    var arrayRes: [Restaurantes]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        arrayRes            <- map["restaurantes"]
    }
}

class Restaurantes: Mappable {
    
    var nombre: String!
    var latitud: Double!
    var longitud: Double!
    var id_establecimiento: Int!
    var tmp: Int!
    var descripcion: String!
    var photo: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        nombre              <- map["nombre"]
        latitud             <- map["latitud"]
        longitud            <- map["longitud"]
        id_establecimiento  <- map["id_establecimiento"]
        tmp                 <- map["tmp"]
        descripcion         <- map["descripcion"]
        photo               <- map["photo"]
    }
}


