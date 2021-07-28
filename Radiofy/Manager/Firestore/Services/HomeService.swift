//
//  HomeService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/07/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct HomeService: HomeModule.Service {
    func saveDocumentToDatabase(imageUrl: String, mainColor: String, name: String, streamUrl: String) {
        
    }
    
    func getStationDetails(with collectionName: String, callback: @escaping (Result<[RadioStation], Error>) -> Void) {
        
    }
    
    func isFullAppAccessAuthorized(callback: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    
}
