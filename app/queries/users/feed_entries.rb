module Users
  class FeedEntries < QueriesBase
    PAGINATION_DEFAULT_COUNT = 10
    DEFAULT_PAGE = 1

    def initialize(user, params)
      @user = user
      @page = params[:page] || DEFAULT_PAGE
      @only_following = params[:only_following]
    end

    def call
      feed_entries.page(page).per(PAGINATION_DEFAULT_COUNT)
    end

    private

    attr_accessor :user, :page, :only_following

    def feed_entries
      collection.with_entryables.order(created_at: :desc)
    end

    def collection
      only_following == 'true' ? Entry.where(user: user.followings) : Entry.all
    end
  end
end
