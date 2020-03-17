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
    
    func loadFriendsData(method: String, parametersDict: [String : String]) {
        
        let parameters: Parameters = parametersDict
        let url = baseUrl + method
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            print(response)
        }
    }
}

