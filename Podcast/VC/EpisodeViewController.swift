//
//  EpisodeViewController.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/15.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class EpisodeViewController: UIViewController {
	
	@IBOutlet weak var ownerLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var episodeImageView: UIImageView!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var playButton: UIButton!
	
	var disposeBag = DisposeBag()
	var currentEpisode: Int!
	var viewModel: EpisodeVCViewModel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.viewModel = EpisodeVCViewModel(dependencies: .init(episodes: HPManager.shared._episodes,
																currentEpisode: currentEpisode))
		bindViewModel()
    }
    

	func bindViewModel() {
		let viewModelInput = EpisodeVCViewModel.Input(didTapPlayButton: playButton.rx.tap.asObservable())
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		viewModelOutput.didChangeEpisode
			.subscribe(onNext: { [weak self] episode in
				self?.ownerLabel.text = episode.author
				self?.titleLabel.text = episode.title
				self?.descTextView.text = episode.description
				let transformer = SDImageResizingTransformer(size: CGSize(width: 400, height: 400), scaleMode: .aspectFill)
				self?.episodeImageView.sd_setImage(with: URL(string: episode.imageUrl ?? ""),
												   placeholderImage: nil,
												   options: .init(),
												   context: [.imageTransformer: transformer])
			})
			.disposed(by: disposeBag)
		
		viewModelOutput.shouldPushToPlayerPage
			.subscribe(onNext: { [unowned self] episode in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerViewController
				vc.currentEpisode = self.currentEpisode
				self.navigationController?.pushViewController(vc, animated: true)
			})
			.disposed(by: disposeBag)
	}
}
