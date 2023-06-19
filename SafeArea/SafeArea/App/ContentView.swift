//
//  ContentView.swift
//  SafeArea
//
//  Created by ChoiYujin on 2023/06/19.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    
    @State var zscodeData: ZscodeData?
    @State var chargingStationModelData : ChargingStation?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(self.chargingStationModelData?.items.item.first?.addr ?? "test")
        }
        .padding()
            .onAppear {
                
                let url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
                let params = ["x" : "129.3252610111111", "y" : "36.0124723151111"] as Dictionary
                let key = Bundle.main.kakaoApiKey!
                print("key : \(key)")
                let headers: HTTPHeaders = ["Authorization": "\(Bundle.main.kakaoApiKey!)"]
                AF.request(url, method: .get ,parameters: params, headers: headers)
                    .responseDecodable(of: ZscodeData.self) { response in
                        guard let data = response.value else {
                            print("Failed to decode dangerInfoArray")
                            return
                        }
                        self.zscodeData = data
                        print(response.value?.documents.first?.code ?? "4711000000")
                        print("\(data.documents.first?.code?.prefix(4) ?? "4711")0")
                        
                        let chargingUrl = "https://apis.data.go.kr/B552584/EvCharger/getChargerInfo?numOfRows=10&pageNo=1&zscode=47110&dataType=JSON&serviceKey=\(Bundle.main.chargingAPIKey!)"
                        
                        let chargingParams = ["numOfRows": "9999", "pageNo": "1", "zscode": "\(data.documents.first?.code?.prefix(4) ?? "4711")0", "dataType": "JSON", "serviceKey": "\(Bundle.main.chargingAPIKey!)"] as Dictionary
                        
                        print("\(Bundle.main.chargingAPIKey!)")
                        
                        AF.request(chargingUrl, method: .get).responseDecodable(of: ChargingStation.self) { response in
                            self.chargingStationModelData = response.value
                            print(self.chargingStationModelData?.items.item.first?.addr)
                        }
                    }
                fetchWeather()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

