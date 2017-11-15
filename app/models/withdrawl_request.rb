class WithdrawlRequest < ApplicationRecord
  belongs_to :member
  belongs_to :coin

  belongs_to :last_changed_by, class_name: 'Member', foreign_key: :last_changed_by_id
  belongs_to :in_progress_by, class_name: 'Member', foreign_key: :in_progress_by_id
  belongs_to :confirmed_by, class_name: 'Member', foreign_key: :confirmed_by_id
  belongs_to :completed_by, class_name: 'Member', foreign_key: :completed_by_id
  belongs_to :cancelled_by, class_name: 'Member', foreign_key: :cancelled_by_id

  STATES = %w(pending in_progress confirmed completed cancelled failed).freeze

  validates :quantity, presence: true,
                       numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

  scope :pending, -> { where state: :pending }
  scope :in_progress, -> { where state: :in_progress }
  scope :confirmed, -> { where state: :confirmed }
  scope :completed, -> { where state: :completed }
  scope :cancelled, -> { where state: :cancelled }
  scope :outstanding, -> { where.not state: [:confirmed, :completed, :cancelled] }

  after_commit :send_admin_notifications, on: :create
  after_commit :send_member_notifications, on: :create

  after_commit :send_admin_notifications, on: :update, if: proc { previous_changes.key?(:state) }
  after_commit :send_member_notifications, on: :update, if: proc { previous_changes.key?(:state) && state != 'confirmed' }

  state_machine :state, initial: :pending do
    event(:progress) { transition pending: :in_progress }
    event(:cancel)      { transition pending: :cancelled }
    event(:confirm)     { transition [:pending, :in_progress] => :confirmed }
    event(:complete)    { transition confirmed: :completed }
    event(:crash)        { transition any: :failed }

    after_transition on: :confirm, do: [:complete_withdrawl!]

    def initialize
      super
    end
  end

  def read_quantity
    quantity.to_d / 10**coin.subdivision
  end

  private

  def complete_withdrawl!
    CompleteWithdrawl.call(withdrawl_request_id: id)
  end

  def send_admin_notifications
    title = I18n.t("withdrawl_request.admins.#{state}.title")
    body = I18n.t("withdrawl_request.admins.#{state}.body", {
      member: member.username,
      quantity: read_quantity,
      coin: coin.code
    })
    Member.admin.each do |admin|
      Notification.create!(
        title: title,
        body: body,
        recipient_id: admin.id,
        subject_id: id,
      )
      Admins::WithdrawlRequestMailer.send(state, admin_id: admin.id, request_id: id).deliver_now
    end
  end

  def send_member_notifications
    title = I18n.t("withdrawl_request.members.#{state}.title")
    body = I18n.t("withdrawl_request.members.#{state}.body", {
      quantity: read_quantity,
      coin: coin.code
    })
    Notification.create!(
      title: title,
      body: body,
      recipient_id: member.id,
      subject_id: id,
    )
    Members::WithdrawlRequestMailer.send(state, request_id: id).deliver_now
  end
end
