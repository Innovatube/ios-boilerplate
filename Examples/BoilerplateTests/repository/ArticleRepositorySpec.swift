import Foundation
import RxSwift
import Quick
import Nimble
import RxBlocking

@testable import Moya
@testable import Boilerplate

final class ArticleRepositorySpec: QuickSpec {

    override func spec() {
        var repo: ArticleRepository!

        describe("200 response") {
            beforeEach {
                let fakeEndpointClosure = { (target: ExampleTarget) -> Endpoint in
                    return Endpoint(url: target.baseURL.absoluteString, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: nil) }
                let network = Network(provider: APIProvider<ExampleTarget>(endpointClosure: fakeEndpointClosure, stubClosure: MoyaProvider<ExampleTarget>.immediatelyStub))
                repo = ArticleRepository(network: network)
            }

            it("top") {
                let result = repo.getTopArticles(limit: 0, offset: 0).toBlocking().materialize()
                switch result {
                case .completed(let elements):
                    let top = elements.first?.first
                    expect(top).toNot(beNil())

                    expect(top?.answerCount) == 5
                    expect(top?.contributor).toNot(beNil())
                    expect(top?.likeCount) == 0
                    expect(top?.metaTag).to(beNil())
                    expect(top?.title) == "『後頭部のふんわり感、絶壁に見えないバランス』 メリハリのある奥行きショートボブスタイル♪"
                    expect(top?.url) == "https://www.cosme.net/beautist/article/2210409"

                    guard let contributor = top?.contributor else {
                        fail("Contributor must not be nil")
                        return
                    }
                    expect(contributor.affiliation) == "LYON hair＆makeup‐リヨン‐"
                    expect(contributor.jobTitle) == "トップデザイナー"
                    expect(contributor.name) == "伊丹 優太"
                case .failed(_, let error):
                    fail("should be resolved: \(error.localizedDescription)")
                }
            }
        }

        describe("401 response") {
            beforeEach {
                let fakeEndpointClosure = { (target: ExampleTarget) -> Endpoint in
                    return Endpoint(url: target.baseURL.absoluteString, sampleResponseClosure: { .networkResponse(200, target.stubbedResponse("bad_request")) }, method: target.method, task: target.task, httpHeaderFields: nil) }
                let network = Network(provider: APIProvider<ExampleTarget>(endpointClosure: fakeEndpointClosure, stubClosure: MoyaProvider<ExampleTarget>.immediatelyStub))
                repo = ArticleRepository(network: network)
            }

            it("Top articles", closure: {
                let result = repo.getTopArticles(limit: 0, offset: 0).toBlocking().materialize()
                guard case MaterializedSequenceResult.failed = result else {
                    fail("Response must be nil")

                    return
                }
            })
        }
    }
}
