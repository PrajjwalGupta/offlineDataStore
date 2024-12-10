//
//  DataModel.swift
//  offlineDataStore
//
//  Created by Prajjwal Gupta on 10/12/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class VideosImages {
    @Attribute(.externalStorage) var videoURL: URL?
    @Attribute(.externalStorage) var imgData: Data?
    var title: String
    var details: String
    var fecha: Date
    var likes: Bool
    
    init(videoURL: URL? = nil, imgData: Data? = nil, title: String, details: String, fecha: Date, likes: Bool) {
        self.videoURL = videoURL
        self.imgData = imgData
        self.title = title
        self.details = details
        self.fecha = fecha
        self.likes = likes
    }
}
