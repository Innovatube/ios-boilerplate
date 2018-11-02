import UIKit
import RxSwift

class HomeArticleContentCell: BindableTableViewCell<Article> {
    @IBOutlet weak var imageViewThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthorDesc: UILabel!
    @IBOutlet weak var imageViewAuthorAvatar: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewAuthorAvatar.cornerRadius = imageViewAuthorAvatar.width / 2.0
        imageViewThumb.pin_updateWithProgress = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func bind(data: Article) {
        imageViewThumb.pin_setImage(data.thumbnailImageUrl)
        lblTitle.text = data.title
        let contributer = data.contributor
        lblAuthorDesc.showContributorDescription(name: contributer?.name, jobTitle: contributer?.jobTitle, affiliation: contributer?.affiliation)
        imageViewAuthorAvatar.pin_setImage(contributer?.imageUrl)
        lblLikeCount.text = String("\(data.likeCount ?? 0)")
    }
}
