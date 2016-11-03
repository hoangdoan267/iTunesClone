//
//  SongEnity.swift
//  Day8
//
//  Created by Hoang Doan on 11/2/16.
//  Copyright © 2016 Hoang Doan. All rights reserved.
//

import Foundation

class SongEnity{
    
    var artworkUrl:String
    var trackCensoredName:String
    var artistName:String
    var trackPrice:Float
    var previewUrl:String
    
    init (trackCensoredName: String, artworkUrl: String, artistName: String,trackPrice: Float, preview: String) {
        self.trackCensoredName = trackCensoredName
        self.artworkUrl = artworkUrl
        self.artistName = artistName
        self.trackPrice = trackPrice
        self.previewUrl = preview
    }
}
