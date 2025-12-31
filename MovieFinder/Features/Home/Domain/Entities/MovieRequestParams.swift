//
//  MovieRequestParams.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 31/7/2568 BE.
//

import Foundation

struct MovieRequestParams: Encodable {
    let page: Int
    let language: String = "en-US"
}
