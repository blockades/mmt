class WithdrawlRequest < ApplicationRecord
  include AggregateRoot

  belongs_to :member
  belongs_to :coin
  belongs_to :last_changed_by, class_name: 'Member', foreign_key: :last_changed_by_id

  STATES = [:pending, :in_progress, :confirmed, :completed, :cancelled].freeze

  after_commit :pending!, on: :create

  def stream
    "Domain::WithdrawlRequest$#{id}"
  end

  def history
    Rails.application.config.event_store.read_stream_events_backward(stream)
  end

  def state
    history.any? ? history.first.data[:state] : nil
  end

  def in_progress_by
    RailsEventStore::Projection.from_stream(stream).init( -> { { admin_id: "" }} )
      .when(Events::Withdrawl::InProgress, ->(state, event) { state[:admin_id] = event.data.fetch(:admin_id) })
  end

  def in_progress!(in_progress_by_id)
    raise ArgumentError.new("in_progress_by_id must be a UUID") unless in_progress_by_id =~ uuid_regex
    return false if [:completed, :confirmed, :cancelled].include? state
    return true if [:in_progress].include? state
    append_to_stream do
      apply Events::Withdrawl::InProgress.new(data: {
        member_id: member_id,
        withdrawl_request_id: id,
        state: :in_progress,
      })
    end
    update! last_changed_by_id: in_progress_by_id
  end

  def confirm!(confirmed_by_id)
    raise ArgumentError.new("admin_id must be a UUID") unless confirmed_by_id =~ uuid_regex
    return false if [:cancelled, :completed].include? state
    return true if [:confirmed].include? state
    append_to_stream do
      apply Events::Withdrawl::Confirmed.new(data: {
        admin_id: confirmed_by,
        member_id: member_id,
        withdrawl_request_id: id,
        state: :confirmed,
      })
    end
    update! last_changed_by_id: confirmed_by_id
  end

  def complete!(completed_by_id)
    raise ArgumentError.new("admin_id must be a UUID") unless completed_by_id =~ uuid_regex
    return true if [:completed].include? state
    return false unless [:confirmed].include? state
    append_to_stream do
      apply Events::Withdrawl::Completed.new(data: {
        admin_id: admin_id,
        member_id: member_id,
        withdrawl_request_id: id,
        state: :completed,
      })
    end
    update! last_changed_by_id: completed_by_id
  end

  def cancel!(cancelled_by_id)
    raise ArgumentError.new("cancelled_by_id must be a UUID") unless cancelled_by_id =~ uuid_regex
    return false if [:in_progress, :completed, :confirmed].include? state
    return true if [:cancelled].include? state
    append_to_stream do
      apply Events::Withdrawl::Cancelled.new(data: {
        member_id: member_id,
        withdrawl_request_id: id,
        state: :cancelled,
      })
    end
    update! last_changed_by_id: cancelled_by_id
  end

  private

  # ===> Aggregate Root and Events

  def pending!
    append_to_stream do
      apply Events::Withdrawl::Pending.new(data: {
        member_id: member_id,
        withdrawl_request_id: id,
        state: :pending,
      })
    end
  end

  def apply_strategy
    DefaultApplyStrategy.new(strict: false)
  end

  def append_to_stream
    self.load(stream)
    yield
    self.store
  end
end
