//
//  UserProfileTVC.swift
//  VKclient
//
//  Created by Станислав Буйновский on 09.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class UserProfileTVC: UITableViewController {

    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let userId = user?.id {
            dataService.loadEducation(userIds: userId)
                .done(on: DispatchQueue.main) { (education) in
                    print("EDUCATION:\(education.universities)")
            }
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else {
            preconditionFailure("Can't deque FriendCell")
        }
        
        let unknownString: String = "Unknown"
        
        switch user?.online {
        case 1:
            cell.userOnline.text = "Online"
            cell.userOnline.textColor = .green
        default:
            cell.userOnline.text = "Offline"
            cell.userOnline.textColor = .red
        }
        
    
        if let imageURL = user?.avatar {
            cell.userAvatarPromise = dataService.loadImage(imageURL: imageURL)
        }
        
        
        cell.userName.text = user?.name
        
        
        if user?.bdate != "" {
            cell.userBdate.text = user?.bdate
        } else {
            cell.userBdate.text = unknownString
        }
       
        
        switch user?.sex {
        case 1:
            cell.userSex.text = "Female"
        case 2:
            cell.userSex.text = "Male"
        default:
            cell.userSex.text = unknownString
        }
        
        
        if user?.city != "" {
            cell.userCity.text = user?.city
        } else {
            cell.userCity.text = unknownString
        }
        
        
        if user?.country != "" {
            cell.userCountry.text = user?.country
        } else {
            cell.userCountry.text = unknownString
        }
        
        
        if user?.homeTown != "" {
            cell.userHomeTown.text = user?.homeTown
        } else {
            cell.userHomeTown.text = unknownString
        }
        
        
        if user?.domain != "" {
            cell.userDomain.text = user?.domain
        } else {
            cell.userDomain.text = unknownString
        }
        
        
        if user?.status != "" {
            cell.userStatus.text = user?.status
        } else {
            cell.userStatus.text = unknownString
        }
        
        
        if user?.nickname != "" {
            cell.userNickname.text = user?.nickname
        } else {
            cell.userNickname.text = unknownString
        }
        
        
        if user?.activities != "" {
            cell.userActivities.text = user?.activities
            cell.userActivities.isScrollEnabled = false
        } else {
            cell.userActivities.text = unknownString
        }
        
        
        if user?.interests != "" {
            cell.userInterests.text = user?.interests
            cell.userInterests.isScrollEnabled = false
        } else {
            cell.userInterests.text = unknownString
        }
        
        
        if user?.music != "" {
            cell.userMusic.text = user?.music
            cell.userMusic.isScrollEnabled = false
        } else {
            cell.userMusic.text = unknownString
        }
        
        
        if user?.movies != "" {
            cell.userMovies.text = user?.movies
            cell.userMovies.isScrollEnabled = false
        } else {
            cell.userMovies.text = unknownString
        }
        
        
        if user?.books != "" {
            cell.userBooks.text = user?.books
            cell.userBooks.isScrollEnabled = false
        } else {
            cell.userBooks.text = unknownString
        }
        
        
        if user?.games != "" {
            cell.userGames.text = user?.games
            cell.userGames.isScrollEnabled = false
        } else {
            cell.userGames.text = unknownString
        }
        

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserProfilePhotosSeague" {
            guard let userProfilePhotoCVC = segue.destination as? UserProfilePhotosCVC else { return }
            userProfilePhotoCVC.user = user
            
        }
    }

}
