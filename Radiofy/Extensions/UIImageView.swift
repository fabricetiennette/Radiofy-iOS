//
//  UIImageView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 06/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

extension UIImageView {

    func getImage(from myUrl: String) {
        guard let url = URL(string: myUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let myData = data, let image = UIImage(data: myData) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }

    func setImage(with reference: StorageReference, placeholder: UIImage? = nil, callback: @escaping (UIColor?) -> Void) {
        let url = URL(string: reference.fullPath)
        self.sd_setImage(with: url, placeholderImage: placeholder) { [weak self] image, _, _, _ in
            guard let me = self else { return }
            let color = image?.averageColor
            callback(color)
            reference.getMetadata { metadata, _ in
                if
                    let cachePath = SDImageCache.shared.cachePath(forKey: reference.fullPath),
                    let attributes = try? FileManager.default.attributesOfItem(atPath: cachePath),
                    let cacheDate = attributes[.creationDate] as? Date,
                    let serverDate = metadata?.timeCreated,
                    serverDate > cacheDate {

                    SDImageCache.shared.removeImage(forKey: reference.fullPath) {
                        me.sd_setImage(with: url, placeholderImage: image) { (image, _, _, _) in
                            let color = image?.averageColor
                            callback(color)
                        }
                    }
                }
            }
        }
    }
}
