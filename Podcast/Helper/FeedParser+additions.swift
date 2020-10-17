//
//  FeedParser+ext.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift
import FeedKit

extension FeedParser {
	func parseRSSFeedObserver() -> Observable<RSSFeed?> {
		return Observable.create { observer in
			_ = self.parseAsync(result: { result in
				switch result {
				case .success(let feed):
					observer.onNext(feed.rssFeed)
					observer.onCompleted()
				case .failure(let err):
					observer.onError(err)
				}
			})
			return Disposables.create()
		}
	}
}
