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
            cell.userOnline.textColor = UIColor.vkGreen
        default:
            cell.userOnline.text = "Offline"
            cell.userOnline.textColor = UIColor.vkRed
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
        setupTextView(textView: cell.userActivities)
        
        cell.userInterests.text = user?.interests
        setupTextView(textView: cell.userInterests)
        
        cell.userMusic.text = user?.music
        setupTextView(textView: cell.userMusic)
        
        cell.userMovies.text = user?.movies
        setupTextView(textView: cell.userMovies)
        
        cell.userBooks.text = user?.books
        setupTextView(textView: cell.userBooks)
        
        cell.userGames.text = user?.games
        setupTextView(textView: cell.userGames)
        
        return cell
    }
    
    
    func fillEducation(user: User?, indexPath: IndexPath) -> UserProfileEducationCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileEducationCell", for: indexPath) as? UserProfileEducationCell else { preconditionFailure("Can't deque FriendCell") }
        
        // create views
        let userSchoolsLabel = UILabel()
        let userSchools = UITextView()
        
        let userUniversitiesLabel = UILabel()
        let userUniversities = UITextView()
        
        cell.contentView.addSubview(userSchoolsLabel)
        cell.contentView.addSubview(userSchools)
        cell.contentView.addSubview(userUniversitiesLabel)
        cell.contentView.addSubview(userUniversities)
        
        userSchoolsLabel.translatesAutoresizingMaskIntoConstraints = false
        userSchools.translatesAutoresizingMaskIntoConstraints = false
        userUniversitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        userUniversities.translatesAutoresizingMaskIntoConstraints = false
        
        [
            userSchoolsLabel.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor, constant: 10) ,
            userSchoolsLabel.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userSchoolsLabel.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            userSchoolsLabel.heightAnchor.constraint(equalToConstant: 20),
            userSchools.topAnchor.constraint(equalTo: userSchoolsLabel.bottomAnchor, constant: 5),
            userSchools.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            userSchools.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 10),
            userSchools.heightAnchor.constraint(equalToConstant: 50),
            userUniversitiesLabel.topAnchor.constraint(equalTo: userSchools.bottomAnchor, constant: 10),
            userUniversitiesLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            userUniversitiesLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 10),
            userUniversitiesLabel.heightAnchor.constraint(equalToConstant: 20),
            userUniversities.topAnchor.constraint(equalTo: userUniversitiesLabel.bottomAnchor, constant: 5),
            userUniversities.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10),
            userUniversities.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 10),
            userUniversities.heightAnchor.constraint(equalToConstant: 50),
            userUniversities.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 10),
            ].forEach { $0.isActive = true }
        
        userSchoolsLabel.text = "Schools:"
        setupLabel(label: userSchoolsLabel)
        
        userUniversitiesLabel.text = "Universities:"
        setupLabel(label: userUniversitiesLabel)
        
        
        if let userId = user?.id {
            dataService.loadEducation(userIds: userId)
                .done(on: DispatchQueue.main) { (education) in
                    self.user?.education = education
                    
                    var schoolsTextBlock = ""
                    var universitiesTextBlock = ""
                    
                    if let schools = user?.education.schools {
                        for school in schools {
                            schoolsTextBlock += "Name: \(school.name)\nGraduation: \(school.yearGraduated)\n"
                            if school != schools.last {
                                schoolsTextBlock += "\n"
                            }
                        }
                    }
                    
                    if let universities = user?.education.universities {
                        for university in universities {
                            universitiesTextBlock += "Name: \(university.name)\nFaculty: \(university.facultyName)\nGraduation: \(university.graduation)\n"
                            if university != universities.last {
                                universitiesTextBlock += "\n"
                            }
                        }
                    }
                    
                    userSchools.text = schoolsTextBlock
                    self.setupTextView(textView: userSchools)
                    
                    userUniversities.text = universitiesTextBlock
                    self.setupTextView(textView: userUniversities)
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserProfilePhotosSeague" {
            guard let userProfilePhotoCVC = segue.destination as? UserProfilePhotosCVC else { return }
            userProfilePhotoCVC.user = user
            
        }
    }
    
    
    func setupLabel(label: UILabel) {
       
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.backgroundColor = UIColor(named: "main_background")
        
    }
    
    
    func setupTextView(textView: UITextView) {
        
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = UIColor(named: "main_background")
        textView.isScrollEnabled = false
        textView.isEditable = false
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
    }

}
