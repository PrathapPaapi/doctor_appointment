require 'rails_helper'

RSpec.describe User, type: :model do
  #schema
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:email).of_type(:string) }

  #validations
  it { is_expected.to validate_length_of(:name).is_at_least(3) }

  it { is_expected.not_to allow_value('pa').for(:name) }
  it { is_expected.not_to allow_value('pa@123').for(:name) }
  it { is_expected.to allow_value('paapi').for(:name) }
  it { is_expected.not_to allow_value('paapi').for(:email) }
  it { is_expected.to allow_value('paapi@fakemail.com').for(:email) }
end
