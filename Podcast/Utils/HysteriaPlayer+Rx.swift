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

extension Reactive where Base: HysteriaPlayer {
	
	public var delegate: DelegateProxy<HysteriaPlayer, HysteriaPlayerDelegate> {
		RxHysteriaPlayerDelegateProxy.proxy(for: base)
	}
	
	public var hysteriaPlayerReadyToPlay: Observable<HysteriaPlayerReadyToPlay> {
		return delegate.methodInvoked(#selector(HysteriaPlayerDelegate.hysteriaPlayerReady(_:)))
			.map { HysteriaPlayerReadyToPlay(rawValue: NSInteger(truncating: $0[0] as! NSNumber))! }
	}
	
	public var hysteriaPlayerWillChangedAtIndex: Observable<Int> {
		return delegate.methodInvoked(#selector(HysteriaPlayerDelegate.hysteriaPlayerWillChanged(at:))).map { $0[0] as! Int }
	}
	
	public var hysteriaPlayerDidReachEnd: Observable<Void> {
		return delegate.methodInvoked(#selector(HysteriaPlayerDelegate.hysteriaPlayerDidReachEnd)).map { _ in return }
	}
}
