//
//  APIModel.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.
//

/// request用情報格納用構造体
struct RequestBodyStruct:Encodable {
    let offset:String?
    let volume:String?
    
    enum CodingKeys: String,CodingKey {
        case offset
        case volume
    }
    
    init(offset: String?, volume: String?) {
        self.offset = offset
        self.volume = volume
    }
}

/// hits情報格納用構造体
struct HitStruct:Decodable {
    let id:String
    let label:String
    let type:String
    let folloersCount:String
    enum CodingKeys: String,CodingKey {
        case id
        case label
        case type
        case folloersCount = "followers_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        let folloersCount = try container.decode(Int.self, forKey: .folloersCount)
        self.folloersCount = String(folloersCount)
    }

}
/// groups情報格納用構造体
struct GroupStruct:Decodable {
    let title : String
    let hits : [HitStruct]
    enum CodingKeys: CodingKey {
        case title
        case hits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.hits = try container.decode([HitStruct].self, forKey: .hits)
    }}

/// sections情報格納用構造体
struct SectionStruct:Decodable {
    let title: String
    let groups: [GroupStruct]
    enum CodingKeys: CodingKey {
        case title
        case groups
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.groups = try container.decode([GroupStruct].self, forKey: .groups)
    }
}
/// api情報格納用構造体(Api内で起きたエラーは考慮してない)
public struct APIStruct:Decodable {
    let sections:[SectionStruct]
    enum CodingKeys: CodingKey {
        case sections
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sections = try container.decode([SectionStruct].self, forKey: .sections)
    }
}

// KeepInfoEntity用構造体
public struct CellInfoEntityStruct {
    // 拡張用
    //（SectionにIDがないためタイトル）
    let sectionTitle: String?
    // 拡張用
    //（GrppにIDがないためタイトル）
    let groupTitle: String?
    // これでCoreDataから消す（プライマリー扱い）
    let hitID: String?
    let hitLabel:String?
    let hitType:String?
    let hitFollowersCount:String?
    init(sectionTitle: String?, groupTitle: String?, hitID: String?, hitLabel: String?, hitType: String?, hitFollowersCount: String?) {
        self.sectionTitle = sectionTitle
        self.groupTitle = groupTitle
        self.hitID = hitID
        self.hitLabel = hitLabel
        self.hitType = hitType
        self.hitFollowersCount = hitFollowersCount
    }
}
