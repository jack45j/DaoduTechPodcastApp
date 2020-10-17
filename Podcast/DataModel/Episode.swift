//
//  Episode.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
	let title: String
	let pubDate: Date
	let description: String
	let author: String
	var imageUrl: String?
	let streamUrl: String
	var fileUrl: String?
	var duration: TimeInterval
  
	init(feedItem: RSSFeedItem) {
		self.title = feedItem.title ?? ""
		self.pubDate = feedItem.pubDate ?? Date()
		self.description = feedItem.iTunes?.iTunesSummary ?? feedItem.description ?? ""
		self.author = feedItem.iTunes?.iTunesAuthor ?? ""
		self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
		self.duration = feedItem.iTunes?.iTunesDuration ?? 0.0
		self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
	}
}
