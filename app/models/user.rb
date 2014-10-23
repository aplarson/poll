# == Schema Information
#
# Table name: users
#
#  id        :integer          not null, primary key
#  user_name :string(255)      not null
#

class User < ActiveRecord::Base
	validates :user_name, uniqueness: true
	validates :user_name, presence: true
	
	has_many(
	:authored_polls,
	class_name: 'Poll',
	foreign_key: :author_id,
	primary_key: :id
	)
	
	has_many(
	:responses,
	class_name: 'Response',
	foreign_key: :user_id,
	primary_key: :id
	)
end
