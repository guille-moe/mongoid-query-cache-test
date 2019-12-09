require 'rails_helper'

RSpec.describe User, type: :model do
  context "with Mongoid::QueryCache" do
    around(:each) do |test|
      Mongoid::QueryCache.enabled = true
      test.run
      Mongoid::QueryCache.enabled = false
      User.delete_all
    end

    it "can query some users twice" do
      2.times { User.create }
      expect do
        User.all.batch_size(4).to_a
        User.all.batch_size(4).to_a
      end.to_not raise_error
    end

    it "can query more than batch size twice" do
      8.times { User.create }
      expect do
        User.all.batch_size(2).to_a
        User.all.batch_size(2).to_a
      end.to_not raise_error
    end
  end
end
