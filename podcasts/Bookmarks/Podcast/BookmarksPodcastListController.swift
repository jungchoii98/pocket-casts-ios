import Combine
import PocketCastsDataModel
import SwiftUI

class BookmarksPodcastListController: ThemedHostingController<BookmarksPodcastListView> {
    private let playbackManager: PlaybackManager
    private let bookmarkManager: BookmarkManager
    private let viewModel: BookmarkPodcastListViewModel

    init(podcast: Podcast,
         bookmarkManager: BookmarkManager = PlaybackManager.shared.bookmarkManager,
         playbackManager: PlaybackManager = .shared) {

        self.bookmarkManager = bookmarkManager
        self.playbackManager = playbackManager

        let sortOption = Constants.UserDefaults.bookmarks.podcastSort
        let viewModel = BookmarkPodcastListViewModel(podcast: podcast,
                                                      bookmarkManager: bookmarkManager,
                                                      sortOption: sortOption)
        viewModel.analyticsSource = .podcasts

        self.viewModel = viewModel
        super.init(rootView: .init(viewModel: viewModel))

        viewModel.router = self
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BookmarkListRouter

extension BookmarksPodcastListController: BookmarkListRouter {
    func bookmarkPlay(_ bookmark: Bookmark) {
        playbackManager.playBookmark(bookmark, source: viewModel.analyticsSource)
        dismiss(animated: true)
    }

    func bookmarkEdit(_ bookmark: Bookmark) {
        let controller = BookmarkEditTitleViewController(manager: bookmarkManager, bookmark: bookmark, state: .updating)
        controller.source = viewModel.analyticsSource

        present(controller, animated: true)
    }

    func dismissBookmarksList() {
        dismiss(animated: true)
    }
}
