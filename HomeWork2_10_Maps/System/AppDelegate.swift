//
//  AppDelegate.swift
//  HomeWork2_10_Maps
//
//  Created by Vlad Ralovich on 11.01.22.
//
//google AIzaSyD_fhmWFK1BBzqYNiaaVsGdPt9JIQF8t-0
//yandex 1cbb6be3-ad08-47cc-bc83-82c7a96d010d

import UIKit
import GoogleMaps
import YandexMapKit
import CoreLocation
import CoreTelephony
import SystemConfiguration

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()
//    var mapKit: YMKMapKit?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyD_fhmWFK1BBzqYNiaaVsGdPt9JIQF8t-0")
        YMKMapKit.setApiKey("1cbb6be3-ad08-47cc-bc83-82c7a96d010d")
//        YMKMapKit.sharedInstance()
//        YMKMapKit.setLocale("ru_RUS")
//        self.mapKit = YMKMapKit.sharedInstance()
//        self.mapKit?.onStart()
        locationManager.requestAlwaysAuthorization()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

