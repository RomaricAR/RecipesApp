//
//  CoreDataManager.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 2/13/25.
//
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "RecipesModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    func save() {
        do {
            try context.save()
        } catch {
            print("❌ Error saving Core Data: \(error)")
        }
    }
    func cacheRecipes(_ recipes: [Recipe]) {
        let context = self.context
        // Clear old cache
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CachedRecipe")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        save()
        // Cache new recipes
        for recipe in recipes {
            let cachedRecipe = CachedRecipe(context: context)
            cachedRecipe.id = recipe.id
            cachedRecipe.name = recipe.name
            cachedRecipe.thumbnailURL = recipe.thumbnailURL
        }
        save()
    }
}
