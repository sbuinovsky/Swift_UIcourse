//
//  FriendProfileController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FriendProfileCVC: UICollectionViewController {
   
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    private let queue: DispatchQueue = DispatchQueue(label: "FriendsProfileCVC_queue", qos: .userInteractive, attributes: [.concurrent])
    
    var photos: [Photo] = []
    var friend: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        guard let friendId = friend?.id else { return }
        
        dataService.loadUserPhotos(targetId: friendId)
            .done(on: DispatchQueue.main) { (photo) in
                self.photos = self.realmService.getUserPhotos(ownerId: friendId)
                self.collectionView.reloadData()
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //количество секций
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //количество ячеек в секции
        return photos.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCell", for: indexPath) as! FriendProfileCell
        
        let imageURL = photos[indexPath.row].imageUrl
        
        //задаем имя пользователя
        cell.friendNameLabel.text = " \(photos[indexPath.row].id)"

        cell.friendProfileImagePromise = dataService.loadImage(imageURL: imageURL)
        
        return cell
    }
    
}
