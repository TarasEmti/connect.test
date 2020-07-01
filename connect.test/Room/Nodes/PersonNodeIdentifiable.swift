//
//  PersonNodeIdentifiable.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

protocol PersonNodeIdentifiable {
    static var nodeName: String { get }
    var uid: String { get }
}
