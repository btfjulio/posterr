class EntrySerializer < ActiveModel::Serializer
  attributes :id, :created_at, :entry_type, :entry_info, :user_id

  delegate :entryable_type, :user_id, to: :entry

  alias entry object
  alias entry_type entryable_type

  def created_at
    entry.created_at.strftime('%B %d, %Y')
  end

  def entry_info
    entryable_serializer.new(entry.entryable).as_json
  end

  def entryable_serializer
    "Entries::#{entry.entryable_type}Serializer".constantize
  end
end
