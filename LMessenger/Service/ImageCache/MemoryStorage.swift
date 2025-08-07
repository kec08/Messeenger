//
//  MemoryStorage.swift
//  LMessenger
//
//  Created by 김은찬 on 8/7/25.
//

import UIKit

protocol MemoryStorageType {
    func value(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}

class MemoryStorage: MemoryStorageType {
    
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
