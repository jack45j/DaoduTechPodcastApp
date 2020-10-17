//
//  MainViewController.swift
//  Podcast
//
//  Created by Yi-Cheng Lin on 2020/10/14.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FeedKit
import RxDataSources
import SDWebImage
import HysteriaPlayer

class MainViewController: UIViewController {
	@IBOutlet weak var homeImageView: UIImageView!
	@IBOutlet weak var homeTableView: UITableView!
	
	var disposeBag = DisposeBag()
	let hysteriaPlayer = HysteriaPlayer.sharedInstance()
	let viewModel: MainVCViewModel! = MainVCViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
		hysteriaPlayer?.datasource = HPManager.shared
		hysteriaPlayer?.enableMemoryCached(true)
		
		homeImageView.contentMode = .scaleAspectFill
		homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTVCell")
	}
	
	func bindViewModel() {
		let viewModelInput = MainVCViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in })
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		viewModelOutput.didParseRSSFeed
			.subscribe(onNext: { [weak self] feed in
				let imageURL = URL(string: feed?.image?.url ?? "")
				self?.homeImageView?.sd_setImage(with: imageURL, completed: nil)
			}, onError: nil)
			.disposed(by: disposeBag)
		
		let dataSource = RxTableViewSectionedReloadDataSource
			<SectionModel<String, Episode>>(configureCell: { (dataSource, tv, indexPath, element) in
				let cell = tv.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTableViewCell
				let transformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 200),
															 scaleMode: .aspectFill)
				cell.episodeImageView?.sd_setImage(with: URL(string: element.imageUrl ?? ""),
												   placeholderImage: nil,
												   options: .init(),
												   context: [.imageTransformer: transformer])
				cell.titleLabel?.text = element.title
				
				// better to use a static singleton formatter for better performace
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyy/M/dd"
				
				cell.pubDateLabel?.text = formatter.string(from: element.pubDate)
				return cell
		})
		
		viewModelOutput.didParseEpisodes
			.map {
				HPManager.shared._episodes = $0?.sorted(by: { $0.pubDate < $1.pubDate }) ?? []
				return [SectionModel(model: "", items: HPManager.shared._episodes ?? [])]
			}
			.bind(to: homeTableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
		
		homeTableView.rx.itemSelected
			.asObservable()
			.subscribe(onNext: { [unowned self] indexPath in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "EpisodeVC") as! EpisodeViewController
				vc.currentEpisode = indexPath.row
				self.navigationController?.pushViewController(vc, animated: true)
			})
			.disposed(by: disposeBag)
	}
}


