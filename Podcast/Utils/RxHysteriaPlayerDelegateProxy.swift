//
//  HysteriaPlayer+Rx.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HysteriaPlayer

//extension HysteriaPlayer: HasDelegate, HasDataSource {
//	public typealias DataSource = HysteriaPlayerDataSource
//	public typealias Delegate = HysteriaPlayerDelegate
//}

public class RxHysteriaPlayerDelegateProxy: DelegateProxy<HysteriaPlayer, HysteriaPlayerDelegate>, DelegateProxyType, HysteriaPlayerDelegate {
	
	public static func currentDelegate(for object: HysteriaPlayer) -> HysteriaPlayerDelegate? {
		object.delegate
	}
	
	public static func setCurrentDelegate(_ delegate: HysteriaPlayerDelegate?, to object: HysteriaPlayer) {
		object.delegate = delegate
	}
	
	public weak private (set) var hysteriaPlayer: HysteriaPlayer?
	
	public static func registerKnownImplementations() {
		self.register { RxHysteriaPlayerDelegateProxy(hysteriaPlayer: $0) }
	}
	
	public init(hysteriaPlayer: HysteriaPlayer) {
		super.init(parentObject: hysteriaPlayer, delegateProxy: RxHysteriaPlayerDelegateProxy.self)
	}
}
