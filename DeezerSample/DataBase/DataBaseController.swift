//
//  DataBaseController.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 30.09.2020.
//

import UIKit
import CoreData

class DataBaseController {
    let context: NSManagedObjectContext
    let entityName = "FavoriteTracks"
    static let shared: DataBaseController = DataBaseController()
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func save(data: AlbumDetailTrackListData, completion: @escaping (Result<String, Error>) -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newTrack = NSManagedObject(entity: entity!, insertInto: context)
        
        newTrack.setValue(data.id, forKey: "id")
        newTrack.setValue(data.albumImage, forKey: "albumImage")
        newTrack.setValue(data.albumName, forKey: "albumName")
        newTrack.setValue(data.artistName, forKey: "artistName")
        newTrack.setValue(data.duration, forKey: "duration")
        newTrack.setValue(data.preview, forKey: "preview")
        newTrack.setValue(data.title, forKey: "title")
        do {
            try context.save()
            completion(.success(""))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch() -> [AlbumDetailTrackListData] {
        var favorites: [AlbumDetailTrackListData] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                favorites.append(AlbumDetailTrackListData(id: data.value(forKey: "id") as! Int,
                                                          albumImage: data.value(forKey: "albumImage") as! String,
                                                          title: data.value(forKey: "title") as! String,
                                                          duration: data.value(forKey: "duration") as! Int,
                                                          preview: data.value(forKey: "preview") as! String,
                                                          artistName: data.value(forKey: "artistName") as! String,
                                                          albumName: data.value(forKey: "albumName") as! String))
            }
        } catch {
            print("Failed")
        }
        return favorites
    }
    
    func deleteTrack(at id: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "id") as! Int == id {
                    context.delete(data)
                }
            }
        } catch {
            print("Failed")
        }
    }
}
