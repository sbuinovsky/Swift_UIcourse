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
    var friendName: String?
    var friendAvatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //количество секций
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //количество ячеек в секции
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCell", for: indexPath) as! FriendProfileCell
        
        //задаем имя пользователя
        cell.friendNameLabel.text = friendName
        cell.friendProfileImage.image = friendAvatar

        return cell
    }
    
}

