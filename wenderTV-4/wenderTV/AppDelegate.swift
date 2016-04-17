/*
* Copyright (c) 2015 Razeware LLC
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
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appController: TVApplicationController?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    let appControllerContext = TVApplicationControllerContext()
    appControllerContext.launchOptions = [
      "initialJSDependencies" : initialJSDependencies()
    ]
    
    let javascriptURL = NSBundle.mainBundle().URLForResource("main",
      withExtension: "js")
    appControllerContext.javaScriptApplicationURL = javascriptURL!
    
    // -------------
    
    TVElementFactory.registerViewElementClass(TVTextElement.self, forElementName: "rainbowText")
    
    TVElementFactory.registerViewElementClass(RainbowProgressElement.self, forElementName: "rainbowProgress")
    
    TVInterfaceFactory.sharedInterfaceFactory().extendedInterfaceCreator = InterfaceFactory.sharedExtendedInterfaceFactory
    
    // -----------------
    
    appController = TVApplicationController(
      context: appControllerContext, window: window,
      delegate: self)

    return true
  }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: TVApplicationControllerDelegate
    
    func appController(appController: TVApplicationController, didFinishLaunchingWithOptions options: [String: AnyObject]?) {
        print("\(#function) invoked with options: \(options)")
    }
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        print("\(#function) invoked with error: \(error)")
        
        let title = "Error Launching Application"
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert )
        
        self.appController?.navigationController.presentViewController(alertController, animated: true, completion: {
            // ...
        })
    }
    
    func appController(appController: TVApplicationController, didStopWithOptions options: [String: AnyObject]?) {
        print("\(#function) invoked with options: \(options)")
    }
    
}

extension AppDelegate {
  private func initialJSDependencies() -> [String] {
    return [
      "mustache.min",
      "ResourceLoader"
      ].flatMap {
        let url = NSBundle.mainBundle().URLForResource($0, withExtension: "js")
        return url?.absoluteString
    }
  }
}


extension AppDelegate : TVApplicationControllerDelegate {
  func appController(appController: TVApplicationController,
    evaluateAppJavaScriptInContext jsContext: JSContext) {
      
      jsContext.setObject(ResourceLoader.self,
        forKeyedSubscript: "NativeResourceLoader")
  }
}

