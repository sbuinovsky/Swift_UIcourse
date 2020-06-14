//
//  GroupViewModelFactory.swift
//  VKclient
//
//  Created by Станислав Буйновский on 14.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift


class GroupsViewModelFactory {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    private var groups: [Group] = []
    
    
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
