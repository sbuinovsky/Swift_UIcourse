//
//  ImageCache.swift
//  VKclient
//
//  Created by Станислав Буйновский on 15.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire


fileprivate protocol Reloadable {
    func reloadRow(index: IndexPath)
}

class ImageCache {
    
    private let cacheLifeTime: TimeInterval = 60 * 5 // 5 minutes interval
    private var images = [String: UIImage]() //RAM imageCache
    private let container: Reloadable // conatiner for Table or Collection
    
    private let syncQueue = DispatchQueue(label: "ImageCache.queue", qos: .userInteractive)
    
    private static let cachePath: String = {
        let pathName = "images/"
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName}
        
        let url = cacheDirectory.appendingPathComponent(pathName)
        
        print("URL PATH: \(url.path)")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return pathName
    }()
    
    
    init (table: UITableView) {
        container = Table(table: table)
    }
    
    
    init (collection: UICollectionView) {
        container = Collection(collection: collection)
    }
    
    
    private func loadImage(indexPath: IndexPath, url: String ) {
        
        Alamofire.request(url).responseData(queue: syncQueue) { [weak self] response in
            guard let data = response.data,
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.images[url] = image
            }
            
            self?.saveImageToCache(url: url, image: image)
            
            DispatchQueue.main.async { [weak self] in
                self?.container.reloadRow(index: indexPath)
            }
        }
        
    }
    
    
    func image(indexPath: IndexPath, url: String) -> UIImage? {
        
        var image: UIImage?
        
        if let cached = images[url] {
            image = cached
        }
        else if let cached = getImageFromFile(url: url) {
            image = cached
        }
        else {
            loadImage(indexPath: indexPath, url: url)
        }
        
        return image
    }
    
    
    private func getFilePath(url: String) -> String? {
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil}
        
        let fileNameURL = url.split(separator: "/").last ?? "default"
        let fileName = fileNameURL.split(separator: "?").first ?? "default"
        
        return cacheDirectory.appendingPathComponent(ImageCache.cachePath + fileName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        
        if let filePath = getFilePath(url: url),
            let data = image.pngData() {
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        }
        
    }
    
    
    private func getImageFromFile(url: String) -> UIImage? {
        
        guard let filePath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filePath),
            let modifiedDate = info[FileAttributeKey.modificationDate] as? Date else { return nil}
        
        let timePassed = Date().timeIntervalSince(modifiedDate)
        
        if timePassed < cacheLifeTime,
            let image = UIImage(contentsOfFile: filePath) {
            images[url] = image
            
            return image
            
        } else {
            
            return nil
        }
    }

}


extension ImageCache {
    
    private class Table: Reloadable {
        
        let table: UITableView
        
        
        init (table: UITableView) {
            self.table = table
        }
        
        
        func reloadRow(index: IndexPath) {
            table.reloadRows(at: [index], with: .automatic)
        }
        
    }
    
    private class Collection: Reloadable {
        
        let collection: UICollectionView
        
        
        init (collection: UICollectionView) {
            self.collection = collection
        }
        
        
        func reloadRow(index: IndexPath) {
            collection.reloadItems(at: [index])
        }
        
    }
}
