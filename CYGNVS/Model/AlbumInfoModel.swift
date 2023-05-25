//
//  AlbumInfoModel.swift
//  CYGNVS
//
//  Created by Subendran on 25/05/23.
//

import Foundation

struct AlbumInfoModel: Codable {

  var albumId      : Int?    = nil
  var id           : Int?    = nil
  var title        : String? = nil
  var url          : String? = nil
  var thumbnailUrl : String? = nil

  enum CodingKeys: String, CodingKey {

    case albumId      = "albumId"
    case id           = "id"
    case title        = "title"
    case url          = "url"
    case thumbnailUrl = "thumbnailUrl"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    albumId      = try values.decodeIfPresent(Int.self    , forKey: .albumId      )
    id           = try values.decodeIfPresent(Int.self    , forKey: .id           )
    title        = try values.decodeIfPresent(String.self , forKey: .title        )
    url          = try values.decodeIfPresent(String.self , forKey: .url          )
    thumbnailUrl = try values.decodeIfPresent(String.self , forKey: .thumbnailUrl )
  }

}
