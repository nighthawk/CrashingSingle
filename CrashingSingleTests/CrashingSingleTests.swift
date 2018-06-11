//
//  CrashingSingleTests.swift
//  CrashingSingleTests
//
//  Created by Adrian Schönig on 11.06.18.
//  Copyright © 2018 Adrian Schönig. All rights reserved.
//

import XCTest

import RxSwift

class CrashingSingleTests: XCTestCase {
  
  var disposeBag: DisposeBag!
  
  override func setUp() {
    super.setUp()
    
    disposeBag = DisposeBag()
  }
  
  func testCrashes() {
    let expectation = self.expectation(description: "Should subscribe")

    let completer = LocationCompleter()
    
    let searchText = "Apple New York"
    
    completer
      .complete(query: searchText)
      .flatMapLatest { completer.location(for: $0.first!) }
      .subscribe(onNext: {
        print($0)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)

    wait(for: [expectation], timeout: 3)
  }
  
  func testChangingSingleTypeToAnyDoesNotCrash() {
    let expectation = self.expectation(description: "Should subscribe")
    
    let completer = LocationCompleter()
    
    let searchText = "Apple New York"
    
    completer
      .complete(query: searchText)
      .flatMapLatest { completer.location2(for: $0.first!) }
      .subscribe(onNext: {
        print("Got: \($0)")
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 3)
  }
  
  func testSameReturnTypeButConstructedDifferentlyIsNotCrashing() {
    let expectation = self.expectation(description: "Should subscribe")
    
    let completer = LocationCompleter()
    
    let searchText = "Apple New York"
    
    completer
      .complete(query: searchText)
      .flatMapLatest { completer.location3(for: $0.first!) }
      .subscribe(onNext: {
        print("Got: \($0)")
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 3)
  }
    
}
