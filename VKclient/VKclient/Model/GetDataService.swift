//
//  GetDataService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire

class GetDataService {
    let baseUrl = "https://api.vk.com/method/"
    
    let apiKey = SessionData.shared.token
    
    func loadFriendsData(method: String, parametersDict: [String : String]) {
        
        var parameters: Parameters = parametersDict
        
        let additionalParam = [
            "access_token" : apiKey,
            "v" : "5.103"
        ]
        
        additionalParam.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            print(response)
        }
    }
}

