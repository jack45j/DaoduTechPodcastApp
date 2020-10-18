//
//  MainVCViewModel.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import FeedKit

class MainVCViewModel: ViewModelType {
	
	/// ViewModel Inputs
	///
	struct Input {
		let viewWillAppear: Observable<Void>
	}
	
	/// ViewModel Outputs
	///
	struct Output {
		let didParseRSSFeed: Observable<RSSFeed?>
		let didParseEpisodes: Observable<[Episode]?>
	}
	
	/// ViewModel Dependencies
	///
	typealias Dependencies = Void
	
	/// initializer of ViewModel
	///
	init() {}
	
	
	/// transform viewModel inputs to outputs
	///
	func transform(input: MainVCViewModel.Input) -> MainVCViewModel.Output {
		
		let feed = input.viewWillAppear
			.debug()
			.map { FeedParser(URL: Endpoints.RSSFeedURL) }
			.flatMap { $0.parseRSSFeedObserver() }
			.share()
		
		let episodes = feed
			.map { $0?.items?.toEpisode() }
			
		return Output(didParseRSSFeed: feed,
					  didParseEpisodes: episodes)
	}
}
