//
//  DataLoader.swift
//  DropBy
//
//  Created by Elise Zhang on 4/9/23.
//

import Foundation

public class DataLoader: ObservableObject {
    @Published var uniJson = [UniversityJson]()
    var universityNames: [String] {
        uniJson.map { $0.institution }
    }
    
    
    
    init(){
        load()
    }
    func load() {
        if let fileLocation = Bundle.main.url(forResource: "us_institutions", withExtension: "json"){
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson =  try jsonDecoder.decode([UniversityJson].self, from: data)
                
                self.uniJson = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    
}
