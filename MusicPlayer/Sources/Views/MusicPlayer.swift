//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by KEEN on 2021/04/23.
//

import Foundation
import AVKit

final class MediaPlayer: UIView {
  // MARK: Properties
  var album: Album

  private lazy var albumCover: UIImageView = {
    let v = UIImageView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.contentMode = .scaleAspectFill
    v.clipsToBounds = true
    v.layer.cornerRadius = 100
    v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    return v
  }()
  
  private lazy var progressBar: UISlider = {
    let v = UISlider()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.addTarget(self, action: #selector(progressScrubbed), for: .valueChanged)
    v.minimumTrackTintColor = UIColor(named: "subtitleColor")
    return v
  }()
  
  // MARK: Labels
  private lazy var albumName: UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.textAlignment = .center
    v.font = .systemFont(ofSize: 32, weight: .bold)
    return v
  }()
  
  private lazy var elapsedTimeLabel: UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.font = .systemFont(ofSize: 14, weight: .light)
    v.text = "00:00"
    return v
  }()
  
  private lazy var remainingTimeLabel: UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.font = .systemFont(ofSize: 14, weight: .light)
    v.text = "00:00"
    return v
  }()
  
  private lazy var songNameLabel: UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.font = .systemFont(ofSize: 16, weight: .bold)
    return v
  }()
  
  private lazy var artistLabel: UILabel = {
    let v = UILabel()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.font = .systemFont(ofSize: 16, weight: .light)
    return v
  }()
  
  // MARK: Buttons
  private lazy var previousButton: UIButton = {
    let v = UIButton()
    v.translatesAutoresizingMaskIntoConstraints = false
    let config = UIImage.SymbolConfiguration(pointSize: 30)
    v.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: config),for: .normal)
    v.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
    return v
  }()
  
  private lazy var playPauseButton: UIButton = {
    let v = UIButton()
    v.translatesAutoresizingMaskIntoConstraints = false
    let config = UIImage.SymbolConfiguration(pointSize: 100)
    v.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config),for: .normal)
    v.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    return v
  }()
  
  private lazy var nextButton: UIButton = {
    let v = UIButton()
    v.translatesAutoresizingMaskIntoConstraints = false
    let config = UIImage.SymbolConfiguration(pointSize: 30)
    v.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: config),for: .normal)
    v.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    return v
  }()
  
  private lazy var controllStack: UIStackView = {
    let v = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
    v.translatesAutoresizingMaskIntoConstraints = false
    v.axis = .horizontal
    v.distribution = .equalSpacing
    v.spacing = 20
    return v
  }()
  
  // MARK: Player
  private var player = AVAudioPlayer()
  private var timer: Timer?
  private var playingIndex = 0
  
  // MARK: Init
  init(album: Album) {
    self.album = album
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  private func setupView() {
    albumName.text = album.name
    albumCover.image = UIImage(named: album.image)
    setupPlayer(song: album.songs[playingIndex])
    
    [albumName, songNameLabel, artistLabel, elapsedTimeLabel, remainingTimeLabel].forEach { (v) in
      v.textColor = .white
    }
    
    [albumName, albumCover, songNameLabel, artistLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controllStack].forEach { (v) in
      addSubview(v)
    }
    
    setupConstraints()
  }

  private func setupConstraints() {
    // album name
    NSLayoutConstraint.activate([
      albumName.leadingAnchor.constraint(equalTo: leadingAnchor),
      albumName.trailingAnchor.constraint(equalTo: trailingAnchor),
      albumName.topAnchor.constraint(equalTo: topAnchor, constant: 16)
    ])
    
    // album cover
    NSLayoutConstraint.activate([
      albumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      albumCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
      albumCover.topAnchor.constraint(equalTo: albumName.topAnchor, constant: 32),
      albumCover.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
    
    // songs name
    NSLayoutConstraint.activate([
      songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      songNameLabel.topAnchor.constraint(equalTo: albumCover.topAnchor, constant: 16),
    ])
    
    // artist label
    NSLayoutConstraint.activate([
      artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      artistLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8),
    ])
    
    // progress bar
    NSLayoutConstraint.activate([
      progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      progressBar.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8)
    ])
    
    // elapsed time
    NSLayoutConstraint.activate([
      elapsedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
    ])
    
    // remaining time
    NSLayoutConstraint.activate([
      remainingTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -16),
      remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
    ])
    
    // control stack
    NSLayoutConstraint.activate([
      controllStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
      controllStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
      controllStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 8)
    ])
  }
  
  private func setupPlayer(song: Song) {
    guard let url = Bundle.main.url(forResource: song.fileName, withExtension: ".mp3") else {
      return
    }
    
    if timer == nil {
      timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    songNameLabel.text = song.name
    artistLabel.text = song.artist
    
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player.delegate = self
      player.prepareToPlay()
      
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  @objc private func updateProgress() {
    
  }
  
  @objc private func progressScrubbed(_ sender: UISlider) {
    
  }
  
  @objc private func didTapPrevious(_ sender: UIButton) {
    
  }
  
  @objc private func didTapPlayPause(_ sender: UIButton) {
    
  }
  
  @objc private func didTapNext(_ sender: UIButton) {
    
  }
}

extension MediaPlayer: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    didTapPlayPause(playPauseButton)
  }
}
