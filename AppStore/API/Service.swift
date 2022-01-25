//
//  Service.swift
//  AppStore
//
//  Created by Лилия on 04.11.2021.
//

import UIKit


class Service {
    
    static let shared = Service() // singleton
    
    func fetchITunesApps(searchText: String, completionHandler: @escaping(SearchResult) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(searchText)&entity=software"
        fetchGenericJSONData(urlString: url, completionHandler: completionHandler)
    }
    
    func fetchTopFreeApps(completionHandler: @escaping(AppGroup) -> ()) {
        let url = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
        fetchGenericJSONData(urlString: url, completionHandler: completionHandler)
    }
    func fetchTopPaidApps(completionHandler: @escaping(AppGroup) -> ()) {
        let url = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchGenericJSONData(urlString: url, completionHandler: completionHandler)
    }
    func fetchAppGroup(urlString: String, completionHandler: @escaping(AppGroup) -> ()) {
        fetchGenericJSONData(urlString: urlString, completionHandler: completionHandler)
    }
    
    func fetchSocialApps(completionHandler: @escaping([SocialApp]) -> ()) {
        let url = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: url, completionHandler: completionHandler)
    }
    
    //generic json function
    func fetchGenericJSONData<T: Decodable>(urlString: String, completionHandler: @escaping (T) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        // Fetch data from Internet
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("DEBUG: Fetching...")
            
            if let error = error {
                print("DEBUG: Failed to fetch data:", error.localizedDescription )
                return
            }
            
            // succses
            guard let data = data else { return }
            
            do {
                let appGroup = try JSONDecoder().decode(T.self, from: data)
                completionHandler(appGroup)
            } catch let JsonError {
                print("DEBUG: Failed to decode data", JsonError)
            }
            
        }).resume() // fires off the request
    }
    
}
