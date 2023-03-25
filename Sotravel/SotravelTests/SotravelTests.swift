//
//  SotravelTests.swift
//  SotravelTests
//
//  Created by Azeem Vasanwala on 15/3/23.
//

import XCTest
@testable import Sotravel
@testable import AsyncHTTPClient
@testable import NIOCore
@testable import NIOHTTP1

final class SotravelTests: XCTestCase {

    //    override func setUpWithError() throws {
    //        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    }
    //
    //    override func tearDownWithError() throws {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    }
    //
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        // Any test you write for XCTest can be annotated as throws and async.
    //        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    //        // Mark your test async to allow awaiting for asynchronous code to complete.
    //        // Check the results with assertions afterwards.
    //    }
    //
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }

    func testNothing() async throws {
        XCTAssertEqual(1, 1)
        let ctx: UserRepository = UserRepositoryNode()
        let val = try await ctx.get(id: UUID(uuidString: "003c8b4a-f831-43c8-9895-bf37da40fa95")!)
        print(val)
    }

    func testNothing2() async throws {
        XCTAssertEqual(1, 1)
        let data: [String: Any] = [
            "id": 99_032_634,
            "first_name": "Larry",
            "last_name": "Lee",
            "photo_url": "https://t.me/i/userpic/320/JCRcwqd9fslCnzRK0TZfezSdbhGhW80LgpboQTpPzbs.jpg",
            "username": "larrylee3107",
            "auth_date": "1678697256",
            "hash": "1beb8304831d3ff306195ecb452887c0e26638c0ba882f254f2c5b4531311a55"
        ]

        //        let resp = try await NodeApi.post(path: .telegramSignIn, data: data)
        //        print(resp)
    }

    func testNothing3() async throws {
        let repo: UserRepository = UserRepositoryNode()
        var user = try await repo.get(id: UUID(uuidString: "003c8b4a-f831-43c8-9895-bf37da40fa95")!)
        user?.firstName = "merry"
        try await repo.update(user: user!)
    }

}
