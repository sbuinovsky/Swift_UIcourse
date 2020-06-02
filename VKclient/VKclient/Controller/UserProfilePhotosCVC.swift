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

class UserProfilePhotosCVC: UICollectionViewController {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    var photos: [Photo] = []
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        guard let userId = user?.id else { return }
        
        dataService.loadUserPhotos(targetId: userId)
            .done(on: DispatchQueue.main) { (photo) in
                self.photos = self.realmService.getUserPhotos(ownerId: userId)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfilePhotoCell", for: indexPath) as! UserProfilePhotoCell
        
        let imageURL = photos[indexPath.row].imageUrl
        
        cell.userProfilePhotoPromise = dataService.loadImage(imageURL: imageURL)
        
        return cell
    }
    
}
