//
//  GroupViewModelFactory.swift
//  VKclient
//
//  Created by Станислав Буйновский on 14.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class GroupViewModelFactory {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    private let queue: DispatchQueue = DispatchQueue(label: "GroupsTVC_queue", qos: .userInteractive)
    
    private var tokens: [NotificationToken] = []
    
    private var groups: [Results<Group>] = []
    
    private let requestUrl = "https://api.vk.com/method/groups.get"
    private let parameters: Parameters = [
        "access_token" : SessionData.shared.token,
        "v" : "5.103",
        "extended" : 1
    ]
    
    private let opq = OperationQueue()
    
    func prepareGroups() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
            realm.refresh()
            let groupsAlphabet = Array( Set( realm.objects(Group.self).compactMap{ $0.name.first?.uppercased() } ) ).sorted()
            groups = groupsAlphabet.map { realm.objects(Group.self).filter("name BEGINSWITH[c] %@", $0) }
            groups.enumerated()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func constructGroupsViewModel(groups: [Group]) -> [GroupViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(group: Group) -> GroupViewModel {
        
        let id = group.id
        let name = group.name
        let avatar = dataService.loadImageByURL(imageURL: group.avatar)
        
        return GroupViewModel(id: id, name: name, avatar: avatar)
    }
}
