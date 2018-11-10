//
//  Note.swift
//  Notes
//
//  Created by Gagan on 2018-04-04.
//  Copyright © 2018 My Org. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Note {
    var id: Int?
    var categoryId: Int?
    var categoryName: String?
    var title: String?
    var text: String?
    var timeUpdated: NSDate?
    var image: UIImage?
    var locationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(text: String) {
        self.text = text
        self.timeUpdated = NSDate()
    }
}
