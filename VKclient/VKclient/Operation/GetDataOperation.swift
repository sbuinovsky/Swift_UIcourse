//
//  GetDataOperation.swift
//  VKclient
//
//  Created by Станислав Буйновский on 28.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire

class GetDataOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}
