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
    
    var outputData: [Group] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let groups: [Group] = json.map { item -> Group in
                let group: Group = .init()
                group.id = item.1["id"].intValue
                group.name = item.1["name"].stringValue
                group.avatar = item.1["photo_200"].stringValue
                return group
            }
            outputData = groups
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
