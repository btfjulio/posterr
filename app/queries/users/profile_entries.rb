module Users
  class ProfileEntries < QueriesBase
    PROFILE_POST_COUNT = 5
    DEFAULT_PAGE = 1

    def initialize(user, params)
      @user = user
      @page = params[:page] || DEFAULT_PAGE
    end

    def call
      profile_entries.page(page).per(PROFILE_POST_COUNT)
    end

    private

    attr_accessor :user, :page

    def profile_entries
      user.entries.with_entryables.order(created_at: :desc)
    end
  end
end
