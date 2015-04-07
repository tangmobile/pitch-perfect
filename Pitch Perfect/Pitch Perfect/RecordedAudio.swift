//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Lee Tang on 4/7/15.
//  Copyright (c) 2015 com.Tang. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathURL: NSURL
    var title: String
    init(filePathURL:NSURL, title:String) {
        self.filePathURL = filePathURL
        self.title = title
    }

}