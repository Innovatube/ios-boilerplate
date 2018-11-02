//
//  APIProvider.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Alamofire
import Moya
import RxSwift

class APIProvider<Target> where Target: Moya.TargetType {

    private let online: Observable<Bool>
    private let provider: MoyaProvider<Target>

    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [NetworkLoggerPlugin(), NetworkErrorTransformPlugin()],
         trackInflights: Bool = false,
         online: Observable<Bool> = .just(true)) {

        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }

    func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return online
            .skipWhile { !$0 }
            .take(1)
            .flatMap { _ in
                return actualRequest
        }
    }
}

protocol APIType {
    associatedtype T: APITargetType

    var provider: APIProvider<T> { get }
}

public struct Network: APIType {
    typealias T = ExampleTarget

    let provider: APIProvider<ExampleTarget>

    init(provider: APIProvider<ExampleTarget> = APIProvider<ExampleTarget>()) {
        self.provider = provider
    }
}
