

import UIKit

import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationData = TheaterList()
    
    let locationManager = CLLocationManager() // 위치를 담당해주는 클래스 인스턴스 생성
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showRequestLocationServiceAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self // 프로토콜 연결
        
        // 앱에서 위치 권한을 허용하지 않을 경우 디폴트 좌표?
        let center = CLLocationCoordinate2D(latitude: 37.546632, longitude: 126.949819)
        setRegionAnnotaion(center: center)
    }
    
    func setRegionAnnotaion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation() // 어노테이션 표시할 인스턴스 생성
        annotation.coordinate = center
        annotation.title = "새싹 영등포 캠퍼스"
        mapView.addAnnotation(annotation)
    }
    
    func setMovieAnnotation() {
        
        
    }
}

extension ViewController {
    
    // 아이폰 설정의 위치 서비스 설정 여부에 따른 분기처리
    func checkUserDeviceLocationAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // 현재 상태를 확인해주는것? 이 부분이 잘 이해가 안된다.
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            // 아이폰 설정의 위치 서비스가 활성화 되어 있으므로, 앱에서의 위치 권한을 요청?
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼짐")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("NotDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Denied, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("When In Use")
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
//    func showAlert() {
//        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//
//        let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
//            <#code#>
//        }
//
//        let lottecinema = UIAlertAction(title: "롯데시네마", style: .default) { _ in
//            <#code#>
//        }
//
//        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
//            <#code#>
//        }
//
//        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
//            <#code#>
//        }
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//
//        alert.addAction(megabox)
//        alert.addAction(lottecinema)
//        alert.addAction(cgv)
//        alert.addAction(all)
//        alert.addAction(cancel)
//
//        present(alert, animated: true, completion: nil)
//    }
}

extension ViewController: CLLocationManagerDelegate { // locationManager 인스턴스를 통해 소통하기 위한 델리게이트 프로토콜 채택?
    
    // 사용자 위치를 가지고 온 경우 표시할 셋팅
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAnnotaion(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    // 가지고 오지 못한 경우 셋팅
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // 권한 상태가 바뀔때마다 알려줘야 하기 때문에 유저 디바이스 기준으로 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationAuthorization()
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    
}




