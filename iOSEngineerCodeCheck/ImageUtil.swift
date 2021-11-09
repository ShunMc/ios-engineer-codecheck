//
//  ImageUtil.swift
//  iOSEngineerCodeCheck
//
//  Created by Matsunobu Shun on 2021/11/09.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class ImageUtil {
    
    class func download(by url: String) async -> UIImage? {
        guard let imgURL = URL(string: url),
              let (data, _)  = try? await URLSession.shared.data(from: imgURL) else {
                  return nil
              }
        
        return UIImage(data: data)
    }
    
}
