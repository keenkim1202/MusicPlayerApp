//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by KEEN on 2021/04/23.
//

import UIKit

// TODO: 음악을 넘길 때 albumCover가 바뀌지 않는 부분 수정
// TODO: 볼륨 조절 slider 추가

final class MusicPlayerViewController: UIViewController {
  // MARK: Properties
  var album: Album
  
  private lazy var mediaPlayer: MediaPlayer = {
    let v = MediaPlayer(album: album)
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  // MARK: Init
  init(album: Album) {
    self.album = album
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mediaPlayer.play()
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  // MARK: Setup
  private func setupView() {
    addBlurredView()
    view.addSubview(mediaPlayer)
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
      mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func addBlurredView() {
    if !UIAccessibility.isReduceMotionEnabled {
      self.view.backgroundColor = UIColor.clear
      
      let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = self.view.bounds
      blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      
      view.addSubview(blurEffectView)
    } else {
      view.backgroundColor = UIColor.black
    }
  }
}
