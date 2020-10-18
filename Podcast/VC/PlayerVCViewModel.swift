//
//  PlayerVCViewModel.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import HysteriaPlayer
import RxSwift

class PlayerVCViewModel: ViewModelType {
	
	let disposeBag = DisposeBag()
	let hysteriaPlayer = HysteriaPlayer.sharedInstance()
	
	let isPlaying = BehaviorSubject<Bool>(value: false)
	let didChangeEpisode = BehaviorSubject<Int>(value: 0)
	let prepareToPlay = BehaviorSubject<Bool>(value: false)
	
	/// ViewModel Inputs
	///
	struct Input {
		let initCurrentEpisode: Observable<Int>
		let shouldPlayNextEpisode: Observable<Void>
		let shouldPlayPreviousEpisode: Observable<Void>
		let shouldPlayOrPauseEpisode: Observable<Void>
		let didChangeEpisodeDuration: Observable<Float>
	}
	struct Output {
		let didChangeEpisode: Observable<Int>
		let readyToPlay: Observable<Bool>
		let isPlaying: Observable<Bool>
	}
	
	/// ViewModel Dependencies
	///
	typealias Dependencies = Void
	
	/// initializer of ViewModel
	///
	init() {}
	
	/// transform viewModel inputs to outputs
	///
	func transform(input: PlayerVCViewModel.Input) -> PlayerVCViewModel.Output {
		
		input.initCurrentEpisode
			.subscribe(onNext: { [unowned self] index in
				self.prepareToPlay.onNext(false)
				self.hysteriaPlayer?.fetchAndPlayPlayerItem(index)
				self.isPlaying.onNext(true)
				self.didChangeEpisode.onNext(index)
			})
			.disposed(by: disposeBag)
		
		input.shouldPlayNextEpisode
			.subscribe(onNext: { [unowned self] _ in
				self.prepareToPlay.onNext(false)
				HPManager.shared.hysteriaPlayer.playNext()
				self.isPlaying.onNext(true)
				self.didChangeEpisode.onNext(HPManager.shared.hysteriaPlayer.getLastItemIndex())
			})
			.disposed(by: disposeBag)
		
		input.shouldPlayPreviousEpisode
			.subscribe(onNext: { [unowned self] _ in
				self.prepareToPlay.onNext(false)
				HPManager.shared.hysteriaPlayer.playPrevious()
				self.isPlaying.onNext(true)
				self.didChangeEpisode.onNext(HPManager.shared.hysteriaPlayer.getLastItemIndex())
			})
			.disposed(by: disposeBag)
		
		input.shouldPlayOrPauseEpisode
			.subscribe(onNext: { [unowned self] _ in
				if HPManager.shared.hysteriaPlayer.isPlaying() {
					HPManager.shared.hysteriaPlayer.pause()
					self.isPlaying.onNext(false)
				} else {
					HPManager.shared.hysteriaPlayer.play()
					self.isPlaying.onNext(true)
				}
			})
			.disposed(by: disposeBag)
		
		input.didChangeEpisodeDuration
			.subscribe(onNext: { value in
				HPManager.shared.hysteriaPlayer.seek(toTime: Double(value))
			})
			.disposed(by: disposeBag)
		
		HPManager.shared.hysteriaPlayer.rx.hysteriaPlayerDidReachEnd
			.subscribe(onNext: { [weak self] _ in
				HPManager.shared.hysteriaPlayer.fetchAndPlayPlayerItem(HPManager.shared._episodes.count - 1)
				HPManager.shared.hysteriaPlayer.pause()
				self?.isPlaying.onNext(false)
			})
			.disposed(by: disposeBag)
		
		let hysteriaPlayerReadyToPlay = HPManager.shared.hysteriaPlayer.rx.hysteriaPlayerReadyToPlay
			.map { HysteriaPlayerReadyToPlay(rawValue: $0.rawValue)! == .currentItem }
		
		let changed = Observable.merge(didChangeEpisode.distinctUntilChanged().map { _ in HPManager.shared.hysteriaPlayer.getLastItemIndex()},
									   HPManager.shared.hysteriaPlayer.rx.hysteriaPlayerWillChangedAtIndex)
		
		
		return PlayerVCViewModel.Output(didChangeEpisode: changed,
										readyToPlay: Observable.merge(hysteriaPlayerReadyToPlay, prepareToPlay.asObserver()),
										isPlaying: isPlaying.asObservable().debug())
	}
}
