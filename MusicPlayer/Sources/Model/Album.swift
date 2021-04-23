//
//  Album.swift
//  MusicPlayer
//
//  Created by KEEN on 2021/04/23.
//

import Foundation

struct Album {
  var name: String
  var image: String
  var songs: [Song]
}

extension Album {
  static func get() -> [Album] {
    return [
      Album(name: "Pop", image: "chungHa_Masquerade", songs:
              [Song(name: "Peaches", image: "justinBieber_peaches", artist: "Justin Bieber", favorite: false, fileName: "justinBieber"),
               Song(name: "Masquerade", image: "chungHa_Masquerade", artist: "청하", favorite: false, fileName: "chungHa"),
               
               Song(name: "꼬리", image: "sunmi_꼬리", artist: "선미", favorite: false, fileName: "sunmi")
              ]),
      Album(name: "K-pop", image: "chungHa_Masquerade", songs:
              [Song(name: "Masquerade", image: "chungHa_Masquerade", artist: "청하", favorite: false, fileName: "chungHa"),
               Song(name: "Peaches", image: "justinBieber_peaches", artist: "Justin Bieber", favorite: false, fileName: "justinBieber"),
               Song(name: "꼬리", image: "sunmi_꼬리", artist: "선미", favorite: false, fileName: "sunmi")
              ]),
      Album(name: "Acoustic", image: "chungHa_Masquerade", songs:
              [Song(name: "꼬리", image: "sunmi_꼬리", artist: "선미", favorite: false, fileName: "sunmi"),
               Song(name: "Masquerade", image: "chungHa_Masquerade", artist: "청하", favorite: false, fileName: "chungHa"),
               Song(name: "Peaches", image: "justinBieber_peaches", artist: "Justin Bieber", favorite: false, fileName: "justinBieber")
              ])
    ]
  }
}
