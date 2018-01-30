//
//  MarkerDataSource.swift
//  Demo
//
//  Created by mac on 2018. 1. 30..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public protocol MarkerDataSource: class {
    func markerCount() -> Int
    func provideMarker(_index: Int) -> Marker
}
