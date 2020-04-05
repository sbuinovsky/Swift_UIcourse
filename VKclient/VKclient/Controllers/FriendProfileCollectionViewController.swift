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

class FriendProfileCollectionViewController: UICollectionViewController {
   
    let dataService: DataServiceProtocol = DataService()
    let realmService: RealmServiceProtocol = RealmService()
    
    //словарь для кэшированных аватаров
    var cachedPhotos = [String: UIImage]()
    
    var photos: [Photo] = []
    var friend: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        guard let friendId = friend?.id else { return }
        
        let apiParameters: [String : Any] = [
            "owner_id" :  friendId,
            "album_id" : "profile",
            ]
        
        dataService.loadPhotos(additionalParameters: apiParameters) {
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
        
        let url = photos[indexPath.row].imageUrl
        
        //задаем имя пользователя
        cell.friendNameLabel.text = " \(photos[indexPath.row].id)"

        DispatchQueue.global().async {
            if let image = self.dataService.getImageByURL(imageURL: url) {
                
                DispatchQueue.main.async {
                   cell.friendProfileImage.image = image
                }
            }
        }
        
        return cell
    }
    
}

