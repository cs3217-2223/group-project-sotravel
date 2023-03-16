//
//  UserCtxNode.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

class ProfileRepositoryNode: ProfileRepository {
    func get() async {
        let resp = await NodeApi.get(path: .profile, params: ["user_id": "634b6038-6594-4473-8c23-a5539400d653"])
        print(resp)
    }

    func update() {

    }
}
