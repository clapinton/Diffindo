# == Schema Information
#
# Table name: bills
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  amount      :float            not null
#  category_id :integer          not null
#  author_id   :integer          not null
#  payer_id    :integer          not null
#  date        :date             not null
#  doc_url     :string
#  split_type  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Bill < ActiveRecord::Base
  validates :title, :amount, :category_id, :author_id, :payer_id, :date, :split_type, presence: true

  # belongs_to :category
  # has_many :comments, dependent: :destroy

  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User

  belongs_to :payer,
    primary_key: :id,
    foreign_key: :payer_id,
    class_name: :User

  has_many :splits, inverse_of: :bill, dependent: :destroy

  # splitUsers = {
    # user1.id: {
      # amount: 45
    # },
    # user2.id: {
      # amount: 55
    # }
  # }

  # splitUsers.keys.map( splitUserId => {
    # split_attrs.push({user_id: splitUserId, amount: splitUsers[splitUserId]})
  # })

  # params = { title: "blabla", amount: 100, ....... , splits_attributes: split_attrs }
  # Bill.create(params)

  # WHAT IF:
  # 1) Bill is invalid? Does it create the bill and/or the splits?
  # 2) Split is invalid? Does it create the bill and/or the splits?

  # See BillsController#bill_params for explanation on allow_destroy
  accepts_nested_attributes_for :splits, allow_destroy: true

  has_many :split_with,
    through: :splits,
    source: :user

end