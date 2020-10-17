//
//  EpisodeVCViewModel.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift

class EpisodeVCViewModel: ViewModelType {
	
	/// ViewModel Inputs
	///
	struct Input {
		let didTapPlayButton: Observable<Void>
	}
	
	/// ViewModel Outputs
	///
	struct Output {
		let didChangeEpisode: Observable<Episode>
		let shouldPushToPlayerPage: Observable<Episode>
	}
	
	/// ViewModel Dependencies
	///
	struct Dependencies {
		let episodes: [Episode]
		let currentEpisode: Int
	}
	private let dependencies: Dependencies!
	
	/// initializer of ViewModel
	///
	init(dependencies: Dependencies? = nil) {
        self.dependencies = dependencies
    }
	
	/// transform viewModel inputs to outputs
	///
	func transform(input: EpisodeVCViewModel.Input) -> EpisodeVCViewModel.Output {
		EpisodeVCViewModel.Output(didChangeEpisode: Observable.just(dependencies.episodes[dependencies.currentEpisode]),
								  shouldPushToPlayerPage: input.didTapPlayButton.map { [unowned self] in self.dependencies.episodes[self.dependencies.currentEpisode] })
	}
}
