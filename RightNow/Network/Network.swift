//
//  Network.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import RxSwift
import RxCocoa
import Alamofire
import Foundation
import RxAlamofire
import SwiftKeychainWrapper

final class Network<T: Decodable> {
    private let endpoint : String
    private let queue : ConcurrentDispatchQueueScheduler
    init(_ endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    //MARK: - Get HTTP
    public func GetNetwork(path: String) -> Observable<T>{
        Observable.create { observer in
            let fullpath = "\(self.endpoint)\(path)"
            AF.request(fullpath, method: .get, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: T.self){ response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //MARK: - Post HTTP
    public func PostNetwork(path: String, params : [String:Any]) -> Observable<T>{
        Observable.create { observer in
            let fullpath = "\(self.endpoint)\(path)"
            AF.request(fullpath, method: .post, parameters: params, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: T.self){ response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //MARK: - Upload File
    
    //MARK: - Ai Network
    public func AiNetwork(params : [String:Any]) -> Observable<T> {
        Observable.create { observer in
            AF.request(AiURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer ", "Content-Type" : "application/json"])
                .validate()
                .responseDecodable(of: T.self){ response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
