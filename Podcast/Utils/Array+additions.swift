//
//  Array+additions.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import FeedKit

extension Array where Element == RSSFeedItem {
	func toEpisode() -> [Episode] {
		return self.map { Episode(feedItem: $0) }
	}
}
