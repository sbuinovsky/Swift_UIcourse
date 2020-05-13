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
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 1:
            let cell = fillEducation(user: user, indexPath: indexPath)
            return cell
        default:
            let cell = fillMainProfile(user: user, indexPath: indexPath)
            return cell
        }
  
    }
    
    
    func fillMainProfile(user: User?, indexPath: IndexPath) -> UserProfileCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else { preconditionFailure("Can't deque FriendCell") }
        
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
        cell.userBdate.text = user?.bdate
        
        switch user?.sex {
        case 1:
            cell.userSex.text = "Female"
        case 2:
            cell.userSex.text = "Male"
        default:
            cell.userSex.text = "unknown"
        }
        
        cell.userCity.text = user?.city
        cell.userCountry.text = user?.country
        cell.userHomeTown.text = user?.homeTown
        cell.userDomain.text = user?.domain
        cell.userStatus.text = user?.status
        cell.userNickname.text = user?.nickname
        
        cell.userActivities.text = user?.activities
        cell.userActivities.isScrollEnabled = false
        
        cell.userInterests.text = user?.interests
        cell.userInterests.isScrollEnabled = false
        
        cell.userMusic.text = user?.music
        cell.userMusic.isScrollEnabled = false
        
        cell.userMovies.text = user?.movies
        cell.userMovies.isScrollEnabled = false
        
        cell.userBooks.text = user?.books
        cell.userBooks.isScrollEnabled = false
        
        cell.userGames.text = user?.games
        cell.userGames.isScrollEnabled = false
        
        return cell
    }
    
    
    func fillEducation(user: User?, indexPath: IndexPath) -> UserProfileEducationCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileEducationCell", for: indexPath) as? UserProfileEducationCell else { preconditionFailure("Can't deque FriendCell") }
        
        if let userId = user?.id {
            dataService.loadEducation(userIds: userId)
                .done(on: DispatchQueue.main) { (education) in
                    self.user?.education = education
                    
                    var schoolsTextBlock = ""
                    var universitiesTextBlock = ""
                    
                    if let schools = user?.education.schools {
                        for school in schools {
                            schoolsTextBlock += "\(school.name)\n\(school.yearGraduated)\n"
                            if school != schools.last {
                                schoolsTextBlock += "\n"
                            }
                        }
                    }
                    
                    if let universities = user?.education.universities {
                        for university in universities {
                            universitiesTextBlock += "\(university.name)\n\(university.facultyName)\n\(university.graduation)\n"
                            if university != universities.last {
                                universitiesTextBlock += "\n"
                            }
                        }
                    }
                    
                    cell.userSchools.text = schoolsTextBlock
                    cell.userSchoolsHeight.constant = self.calcHeight(textView: cell.userSchools)
                    
                    cell.userUniversities.text = universitiesTextBlock
                    cell.userUniversitiesHeight.constant = self.calcHeight(textView: cell.userUniversities)
            }
        }
        
       
        
        print(cell.userUniversities.text)
        print(cell.userSchools.text)
        
        return cell
    }
    
    
    func calcHeight(textView: UITextView) -> CGFloat {
        let size = CGSize(width: self.tableView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        return estimateSize.height
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserProfilePhotosSeague" {
            guard let userProfilePhotoCVC = segue.destination as? UserProfilePhotosCVC else { return }
            userProfilePhotoCVC.user = user
            
        }
    }

}
