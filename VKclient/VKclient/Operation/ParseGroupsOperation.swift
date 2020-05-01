//
//  ParseGroupsOperation.swift
//  VKclient
//
//  Created by Станислав Буйновский on 28.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import SwiftyJSON

class ParseGroupsOperation: Operation {
    
    private let realmService: RealmServiceProtocol = RealmService()
    
    var outputData: [Group] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let groups: [Group] = json["response"]["items"].compactMap {
                let group = Group()
                group.id = $0.1["id"].intValue
                group.name = $0.1["name"].stringValue
                group.avatar = $0.1["photo_100"].stringValue
                return group
            }
            outputData = groups
            
            try realmService.saveObjects(objects: outputData)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
