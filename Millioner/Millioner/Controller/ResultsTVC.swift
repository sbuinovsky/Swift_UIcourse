//
//  ResultsTVC.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class ResultsTVC: UITableViewController {

    private let results = Game.shared.getResults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTVCCell", for: indexPath) as! ResultsTVCCell

        let result = results[indexPath.row]
        
        cell.idLabel.text = "\(result.id)"
        cell.persentageLabel.text = "Percentage: \(result.percentage)%"
        cell.balanceLabel.text = "Balance: \(result.balance)"

        return cell
    }

}
