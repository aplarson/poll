# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  choice      :text             not null
#

class AnswerChoice < ActiveRecord::Base
	validates :question_id, :choice, presence: true
	
	belongs_to(
	:question,
	class_name: 'Question',
	foreign_key: :question_id,
	primary_key: :id
	)
	
	has_many(
	:responses,
	class_name: 'Response',
	foreign_key: :answer_choice_id,
	primary_key: :id,
	dependent: :destroy
	)
end
