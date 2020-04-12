//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsTVC: UITableViewController {

//    Нужно исправить полностью этот контроллер!!!
    
    let groups: [Group] = []
    
    let newsText = ["Далеко-далеко за словесными горами в стране гласных и согласных живут рыбные тексты. Вдали от всех живут они в буквенных домах на берегу Семантика большого языкового океана. Маленький ручеек Даль журчит по всей стране и обеспечивает ее всеми необходимыми правилами. Эта парадигматическая страна, в которой жаренные члены предложения залетают прямо в рот. Даже всемогущая пунктуация не имеет власти над рыбными текстами, ведущими безорфографичный образ жизни. Однажды одна маленькая строчка рыбного текста по имени Lorem ipsum решила выйти в большой мир грамматики.",
        "Далеко-далеко за словесными горами в стране гласных и согласных живут рыбные тексты. Вдали от всех живут они в буквенных домах на берегу Семантика большого языкового океана.",
        "Далеко-далеко за словесными горами в стране гласных и согласных живут рыбные тексты. Вдали от всех живут они в буквенных домах на берегу Семантика большого языкового океана. Маленький ручеек Даль журчит по всей стране и обеспечивает ее всеми необходимыми правилами.",
        "UITextView supports the display of text using custom style information and also supports text editing. You typically use a text view to display multiple lines of text, such as when displaying the body of a large text document. This class supports multiple text styles through use of the attributedText property. (Styled text is not supported in versions of iOS earlier than iOS 6.) Setting a value for this property causes the text view to use the style information provided in the attributed string. You can still use the font, textColor, and textAlignment properties to set style attributes, but those properties apply to all of the text in the text view. It’s recommended that you use a text view—and not a UIWebView object—to display both plain and rich text in your app."
    ]
    
    var likeBox = Like()
    let date: Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsText.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
               preconditionFailure("Can't deque NewsCell")
            
        }
        
        //рабочая константа выбора элемента групп
        let group = groups[indexPath.row]
        
        //рабочая константа выбора текстов новостей
        let newsSingleText = newsText[indexPath.row]
        
        //обработка даты в String формат
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // тут может быть любой нужный вам формат, гуглите как писать форматы
        let convertedDate = dateFormatter.string(from: date)
        
        
        
        //заполняем начальными значениями
//        cell.groupImage.image = group.avatar
        cell.groupName.text = group.name
        cell.date.text = convertedDate
        cell.textField.text = newsSingleText
        cell.textField.translatesAutoresizingMaskIntoConstraints = true
        cell.textField.sizeToFit()
        cell.likeImage.image = likeBox.image
        cell.likeCounter.text = "\(likeBox.counter)"
        cell.shareButton.image = UIImage(imageLiteralResourceName: "shareImage")
        cell.commentsButton.image = UIImage(imageLiteralResourceName: "commentsImage")
        cell.newsImage.image = UIImage(imageLiteralResourceName: "newsImage")
        cell.viewsImage.image = UIImage(imageLiteralResourceName: "viewsImage")
        
        return cell
    }

}
