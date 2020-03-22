//
//  FriendProfileController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendProfileCollectionViewController: UICollectionViewController {
    let getDataService: PhotosDataServiceProtocol = PhotosDataService(parser: PhotosSwiftyJSONParser())
    
    var photos: [Photo] = []
    var friends: [User] = []

    var friendName: String?
    var friendAvatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        friends = friends.filter({friendName!.contains($0.name)})
        guard let friendId = friends.first?.id else { return }
        
        let apiParameters: [String : Any] = [
            "owner_id" :  friendId,
            "album_id" : "profile",
            ]
        
        getDataService.loadData(additionalParameters: apiParameters) { (photos) in
            self.photos = photos
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
        
        //задаем имя пользователя
        cell.friendNameLabel.text = " \(photos[indexPath.row].id)"
        cell.friendProfileImage.image = getImageByURL(imageUrl: photos[indexPath.row].imageUrl)

        return cell
    }
    
}

