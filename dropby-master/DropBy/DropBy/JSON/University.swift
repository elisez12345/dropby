//
//  University.swift
//  DropBy
//
//  Created by Elise Zhang on 4/9/23.
//

import Foundation

struct UniversityJson: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case institution
    }
    var id = UUID()
    var institution: String
    var university_list: [String] = []
    
//    ForEach(dataLoader.uniJson) {uni in
//        university_list.append(uni.institution)
//    }
}
