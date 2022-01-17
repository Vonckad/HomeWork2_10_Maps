//
//  ViewController.swift
//  HomeWork2_10_Maps
//
//  Created by Vlad Ralovich on 11.01.22.
//

import UIKit
import MapKit
import GoogleMaps
import YandexMapKit

class MainViewController: UIViewController {
    
    var menuButton: UIButton!
    var isShowMenu = false
    var currentMapView: UIView!
    var appleButton: UIButton!
    var googleButton: UIButton!
    var yandexButton: UIButton!
    var inZoomButton: UIButton!
    var outZoomButton: UIButton!
    var currentPositionButton: UIButton!
    
    let appleMapView = MKMapView()
    var googleMapView = GMSMapView()
    var initZoomGoogleMapView: Float = 14
    var initZoomYandexMapView: Float = 14
    var yandexMapView = YMKMapView()
    let yandexMapKit = YMKMapKit.sharedInstance()
    var yandexUserLocation: YMKUserLocationLayer?
    
    var artworks: [Artwork] = [
        Artwork(title: "Пешеходный проспект Чумбарова-Лучинского", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53552490468529, longitude: 40.52725168714141)),
        Artwork(title: "Набережная Северной Двины", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.538789, longitude: 40.508615)),
        Artwork(title: "Петровский сквер", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53619073003384, longitude: 40.512906206959336)),
        Artwork(title: "Памятник жертвам интервенции", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.53517048298956, longitude: 40.51493828805515)),
        Artwork(title: "Обелиск Севера", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 64.54091406729562, longitude: 40.514305230384494))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init googleMapView
        let initialLocation = CLLocation(latitude: 64.538686, longitude: 40.518267)
        googleMapView = .map(withFrame: view.frame, camera: GMSCameraPosition(target: initialLocation.coordinate, zoom: initZoomGoogleMapView))
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        view.addSubview(googleMapView)
        googleMapView.isHidden = true
        
        //init yandexMapView
        yandexMapView.frame = view.bounds
        yandexMapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude), zoom: initZoomYandexMapView, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil)
        yandexUserLocation = yandexMapKit.createUserLocationLayer(with: yandexMapView.mapWindow)
        yandexUserLocation?.setVisibleWithOn(true)
        yandexUserLocation?.isHeadingEnabled = true

        view.addSubview(yandexMapView)
        yandexMapView.isHidden = true
        
        appleMapView.delegate = self
        appleMapView.frame = view.bounds
        appleMapView.setUserTrackingMode(.follow, animated: true)
        view.addSubview(appleMapView)
        currentMapView = appleMapView
        appleMapView.centerToLocation(initialLocation, regionRadius: 2000)
        appleMapView.addAnnotations(artworks)
        
        setupButtons()
        setupMenuButtons()
        
        let objectsYandex = yandexMapView.mapWindow.map.mapObjects
        // add markers on google map
        for (index, artwork) in artworks.enumerated() {
            let marker = GMSMarker()
            marker.position = artwork.coordinate
            marker.title = artwork.title
            marker.icon = UIImage(named: "\(index + 1)")
            marker.map = googleMapView
            // add markers on yandex map
            objectsYandex.addPlacemark(with: YMKPoint(latitude: artwork.coordinate.latitude, longitude: artwork.coordinate.longitude), image: UIImage(named: "\(index + 1)")!)
        }
    }
    
    fileprivate func setupButtons() {
        //MARK: - menuButton
        menuButton = UIButton(frame: .zero)
        menuButton.setTitle(" Menu ", for: .normal)
        menuButton.setTitleColor(.systemTeal, for: .normal)
        menuButton.titleLabel?.font = .boldSystemFont(ofSize: 38)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.layer.cornerRadius = 8
        menuButton.layer.borderWidth = 2
        menuButton.layer.borderColor = UIColor.systemTeal.cgColor
        menuButton.addTarget(self, action: #selector(showMenuObjc), for: .touchUpInside)
        view.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        menuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        //MARK: - ZoomButtons
        inZoomButton = UIButton(frame: CGRect(x: view.bounds.maxX - 72, y: view.bounds.midY - 72, width: 64, height: 64))
        inZoomButton.addTarget(self, action: #selector(inZoom), for: .touchUpInside)
        inZoomButton.setImage(UIImage(named: "zoom-in"), for: .normal)
        
        outZoomButton = UIButton(frame: CGRect(x: view.bounds.maxX - 72, y: view.bounds.midY, width: 64, height: 64))
        outZoomButton.addTarget(self, action: #selector(outZoom), for: .touchUpInside)
        outZoomButton.setImage(UIImage(named: "zoom-out"), for: .normal)
        
        currentPositionButton = UIButton(frame: CGRect(x: view.bounds.maxX - 72, y: view.bounds.midY + 72, width: 64, height: 64))
        currentPositionButton.addTarget(self, action: #selector(camera), for: .touchUpInside)
        currentPositionButton.setImage(UIImage(named: "position"), for: .normal)
        
        view.addSubview(inZoomButton)
        view.addSubview(outZoomButton)
        view.addSubview(currentPositionButton)
    }
    
    fileprivate func setupMenuButtons() {
        appleButton = UIButton(frame: CGRect(x: view.frame.midX - 170, y: view.frame.midY - 50, width: 100, height: 100))
        appleButton.setImage(UIImage(named: "apple"), for: .normal)
        appleButton.setTitleColor(.systemPink, for: .normal)
        appleButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        appleButton.addTarget(self, action: #selector(showAppleMap), for: .touchUpInside)
        view.addSubview(appleButton)
        appleButton.isHidden = true
        
        googleButton = UIButton(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY - 50, width: 100, height: 100))
        googleButton.setImage(UIImage(named: "google"), for: .normal)
        googleButton.setTitleColor(.systemBlue, for: .normal)
        googleButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        googleButton.addTarget(self, action: #selector(showGoogleMap), for: .touchUpInside)
        view.addSubview(googleButton)
        googleButton.isHidden = true
        
        yandexButton = UIButton(frame: CGRect(x: view.frame.midX + 70, y: view.frame.midY - 50, width: 100, height: 100))
        yandexButton.setImage(UIImage(named: "yandex"), for: .normal)
        yandexButton.setTitleColor(.systemBlue, for: .normal)
        yandexButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        yandexButton.addTarget(self, action: #selector(showYandexMap), for: .touchUpInside)
        view.addSubview(yandexButton)
        yandexButton.isHidden = true
    }
    
    @objc func showMenuObjc() {
        isShowMenu = !isShowMenu
        appleButton.isHidden = isShowMenu ? false : true
        googleButton.isHidden = isShowMenu ? false : true
        yandexButton.isHidden = isShowMenu ? false : true
        inZoomButton.isHidden = isShowMenu ? true : false
        outZoomButton.isHidden = isShowMenu ? true : false
        currentPositionButton.isHidden = isShowMenu ? true : false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 9
        blurEffectView.frame = view.frame
        print("showMenu")

        if isShowMenu {
            view.addSubview(blurEffectView)
            
            let indexMenuButton = self.view.subviews.firstIndex(of: menuButton)
            let indexBlurEffectView = self.view.subviews.firstIndex(of: blurEffectView)
            let indexAppleButton = self.view.subviews.firstIndex(of: appleButton)
            let indexGoogleButton = self.view.subviews.firstIndex(of: googleButton)
            let indexYandexButton = self.view.subviews.firstIndex(of: yandexButton)
            
            self.view.exchangeSubview(at: indexMenuButton!, withSubviewAt: indexBlurEffectView!)
            self.view.exchangeSubview(at: indexBlurEffectView!, withSubviewAt: indexAppleButton!)
            self.view.exchangeSubview(at: indexBlurEffectView!, withSubviewAt: indexGoogleButton!)
            self.view.exchangeSubview(at: indexBlurEffectView!, withSubviewAt: indexYandexButton!)
            
            switch currentMapView {
            case is MKMapView:
                appleButton.isEnabled = false
            case is GMSMapView:
                googleButton.isEnabled = false
            case is YMKMapView:
                yandexButton.isEnabled = false
            default:
                break
            }
        } else {
            view.viewWithTag(9)?.removeFromSuperview()
        }
    }
    
    func zoom(_ bool: Bool) {
       
        switch currentMapView {
        case is MKMapView:
            var region = appleMapView.region
            var span = MKCoordinateSpan()
            span.latitudeDelta = bool ? region.span.latitudeDelta / 2 : region.span.latitudeDelta * 2
            span.longitudeDelta = bool ? region.span.longitudeDelta / 2 : region.span.longitudeDelta * 2
            region.span = span
            appleMapView.setRegion(region, animated: false)
        case is GMSMapView:
            if bool {
                initZoomGoogleMapView += 1
            } else {
                initZoomGoogleMapView -= 1
            }
            googleMapView.animate(toZoom: initZoomGoogleMapView)
        case is YMKMapView:
            print("YMKMapView")
            
            if bool {
                initZoomYandexMapView += 1
            } else {
                initZoomYandexMapView -= 1
            }
            let cameraPosition = yandexMapView.mapWindow.map.cameraPosition
            let position = YMKCameraPosition(target: cameraPosition.target, zoom: initZoomYandexMapView, azimuth: 0, tilt: 0)
            yandexMapView.mapWindow.map.move(with: position, animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.33))
        default:
            break
        }
    }
    
    @objc func inZoom() {
        zoom(true)
    }
    @objc func outZoom() {
        zoom(false)
    }
    // show current user location
    @objc func camera() {
        switch currentMapView {
        case is MKMapView:
            guard let location = appleMapView.userLocation.location else { return }
            appleMapView.centerToLocation(location, regionRadius: 1000)
        case is GMSMapView:
            guard let location = googleMapView.myLocation else { return }
            googleMapView.animate(toLocation: location.coordinate)
            initZoomGoogleMapView = 16
            googleMapView.animate(toZoom: initZoomGoogleMapView)
        case is YMKMapView:
            initZoomYandexMapView = 16
            let position = YMKCameraPosition(target: yandexUserLocation!.cameraPosition()!.target, zoom: initZoomYandexMapView, azimuth: 0, tilt: 0)
            yandexMapView.mapWindow.map.move(with: position, animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1))
        default:
            break
        }
    }
    @objc func showAppleMap() {
        currentMapView = appleMapView
        showMenuObjc()
        googleMapView.isHidden = true
        yandexMapView.isHidden = true
        appleMapView.isHidden = false
        googleButton.isEnabled = true
        yandexButton.isEnabled = true

    }
    @objc func showGoogleMap() {
        currentMapView = googleMapView
        showMenuObjc()
        appleMapView.isHidden = true
        googleMapView.isHidden = false
        appleButton.isEnabled = true
        yandexButton.isEnabled = true
        yandexMapView.isHidden = true
    }
    @objc func showYandexMap() {
        currentMapView = yandexMapView
        showMenuObjc()
        appleMapView.isHidden = true
        googleMapView.isHidden = true
        appleButton.isEnabled = true
        googleButton.isEnabled = true
        yandexMapView.isHidden = false
    }
}

//MARK: - extension MainViewController: MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var ant = mapView.dequeueReusableAnnotationView(withIdentifier: "ant")
        if ant == nil {
            ant = MKAnnotationView(annotation: annotation, reuseIdentifier: "ant")
        } else {
            ant?.annotation = annotation
        }
        
        switch annotation.title {
        case artworks[0].title:
            ant?.image = UIImage(named: "1")
        case artworks[1].title:
            ant?.image = UIImage(named: "2")
        case artworks[2].title:
            ant?.image = UIImage(named: "3")
        case artworks[3].title:
            ant?.image = UIImage(named: "4")
        case artworks[4].title:
            ant?.image = UIImage(named: "5")
        default:
            break
        }
     return ant
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title!! ?? "")
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

//MARK: - extension MainViewController: GMSMapViewDelegate
extension MainViewController: GMSMapViewDelegate {
    
}

//MARK: - extension MainViewController: YMKUserLocationObjectListener
extension MainViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        print("onObjectAdded")
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        
        pinPlacemark.setIconWithName("icon",
            image: UIImage(named:"Icon")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0, y: 0) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: true,
                visible: true,
                scale: 1.5,
                tappableArea: nil))
        
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))

        view.accuracyCircle.fillColor = UIColor.blue
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        print("onObjectRemoved")
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        print("onObjectUpdated")
    }
    
    
}
