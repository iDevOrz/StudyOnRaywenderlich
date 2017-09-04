/*
* Copyright (c) 2017 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let navigationController = window!.rootViewController as! UINavigationController
    let controller = navigationController.topViewController as! MasterViewController
    controller.managedObjectContext = self.managedObjectContext
    
    prepareNavigationBarAppearance()

    return true
  }
  
  func prepareNavigationBarAppearance() {
    
    let barColor = UIColor(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    
    UINavigationBar.appearance().barTintColor = barColor
    UINavigationBar.appearance().tintColor = UIColor.white
    
    let font = UIFont(name: "Avenir-Black", size: 30)!
    let regularVertical = UITraitCollection(verticalSizeClass: .regular)
    let titleDict: [String: Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: font]
    
    UINavigationBar.appearance(for: regularVertical).titleTextAttributes = titleDict
    
    UIToolbar.appearance().barTintColor = barColor
    UIToolbar.appearance().tintColor = UIColor.white
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
    
    UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
  }
  
  
  func applicationWillTerminate(_ application: UIApplication) {
    saveContext()
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let persistentContainer = NSPersistentContainer(name: "TouchMeIn")
    persistentContainer.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        print(error)
      } else {
        print("Core Data initiated")
      }
    }
    return persistentContainer
  }()
  
  var managedObjectContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  
  // MARK: - Core Data Saving support
  
  func saveContext() {
    
    guard managedObjectContext.hasChanges else {
      return
    }
    
    do {
      try managedObjectContext.save()
    } catch {
      print(error)
    }
  }
}

