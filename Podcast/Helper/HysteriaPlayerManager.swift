//
//  HysteriaPlayerManager.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/16.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import HysteriaPlayer

class HPManager: NSObject {
	static let shared = HPManager()
	let hysteriaPlayer = HysteriaPlayer.sharedInstance()!
	var _episodes: [Episode]!
}

extension HPManager: HysteriaPlayerDataSource {
	func hysteriaPlayerNumberOfItems() -> Int {
		self._episodes.count
	}
	
	func hysteriaPlayerURLForItem(at index: Int, preBuffer: Bool) -> URL! {
		return URL(string: self._episodes[index].streamUrl)!
	}
}
