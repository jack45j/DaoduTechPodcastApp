//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage
import HysteriaPlayer

class PlayerViewController: UIViewController {
	@IBOutlet weak var episodeImageView: UIImageView!
	@IBOutlet weak var episodeTitleLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var previousButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var durationSlider: UISlider!
	
	let disposeBag = DisposeBag()
	var currentEpisode: Int!
	var viewModel: PlayerVCViewModel! = PlayerVCViewModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		bindViewModel()
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
			self?.durationSlider.value = HPManager.shared.hysteriaPlayer.getPlayingItemCurrentTime()
		})
		durationSlider.isContinuous = false
    }
	
	func bindViewModel() {
		let viewModelInput = PlayerVCViewModel.Input(initCurrentEpisode: Observable.just(currentEpisode),
													 shouldPlayNextEpisode: nextButton.rx.tap.asObservable(),
													 shouldPlayPreviousEpisode: previousButton.rx.tap.asObservable(),
													 shouldPlayOrPauseEpisode: playButton.rx.tap.asObservable(),
													 didChangeEpisodeDuration: durationSlider.rx.value.changed.asObservable())
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		viewModelOutput.didChangeEpisode
			.subscribe(onNext: { [weak self] index in
				let transformer = SDImageResizingTransformer(size: CGSize(width: 400, height: 400), scaleMode: .aspectFill)
				self?.episodeImageView.sd_setImage(with: URL(string: HPManager.shared._episodes[index].imageUrl ?? ""),
												   placeholderImage: nil,
												   options: .init(),
												   context: [.imageTransformer: transformer])
				self?.durationSlider.maximumValue = Float(HPManager.shared._episodes[index].duration)
				
				self?.episodeTitleLabel.text = HPManager.shared._episodes[index].title
			})
			.disposed(by: disposeBag)
		
		viewModelOutput.readyToPlay
			.subscribe(onNext: { [weak self] isReady in
				let lastItemIndex = HPManager.shared.hysteriaPlayer.getLastItemIndex()
				self?.nextButton.isEnabled = lastItemIndex != HPManager.shared._episodes.count - 1
				self?.previousButton.isEnabled = lastItemIndex != 0
				self?.playButton.isEnabled = true
			})
			.disposed(by: disposeBag)
		
		viewModelOutput.isPlaying
			.debug()
			.subscribe(onNext: { [unowned self] isPlaying in
				isPlaying ?
					self.playButton.setImage(UIImage(named: "pause-button"), for: .normal) :
					self.playButton.setImage(UIImage(named: "play-button"), for: .normal)
			})
			.disposed(by: disposeBag)
	}
}
