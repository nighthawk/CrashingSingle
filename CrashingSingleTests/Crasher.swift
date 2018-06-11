//
//  Crasher.swift
//  Share
//
//  Created by Adrian Schönig on 11.06.18.
//  Copyright © 2018 Adrian Schönig. All rights reserved.
//

import Foundation
import MapKit

import RxSwift

public class LocationCompleter: NSObject {
  
  let results = PublishSubject<[MKLocalSearchCompletion]>()
  
  private lazy var completer: MKLocalSearchCompleter = {
    let completer = MKLocalSearchCompleter()
    completer.delegate = self
    return completer
  }()
  
  public func complete(query: String) -> Observable<[MKLocalSearchCompletion]> {
    completer.filterType = .locationsOnly
    
    defer { self.completer.queryFragment = query }
    return results
  }
  
  public func location(for completion: MKLocalSearchCompletion) -> Single<[MKMapItem]> {
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    return Single.create { subscriber in
      search.start { response, error in
        if let error = error {
          subscriber(.error(error))
        } else {
          subscriber(.success(response?.mapItems ?? []))
        }
      }
      return Disposables.create()
    }
  }
  
  public func location2(for completion: MKLocalSearchCompletion) -> Single<[Any]> {
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    return Single.create { subscriber in
      search.start { response, error in
        if let error = error {
          subscriber(.error(error))
        } else {
          subscriber(.success(response?.mapItems ?? []))
        }
      }
      return Disposables.create()
    }
  }
  
  public func location3(for completion: MKLocalSearchCompletion) -> Single<[MKMapItem]> {
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    return Observable.create { subscriber in
        search.start { response, error in
          if let error = error {
            subscriber.onError(error)
          } else {
            subscriber.onNext(response?.mapItems ?? [])
            subscriber.onCompleted()
          }
        }
        return Disposables.create()
      }
      .asSingle()
  }
  
}

extension LocationCompleter: MKLocalSearchCompleterDelegate {

  public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    results.onNext(completer.results)
  }
  
}
