# == Schema Information
#
# Table name: questions
#
#  id      :integer          not null, primary key
#  poll_id :integer          not null
#  body    :text             not null
#

class Question < ActiveRecord::Base
	validates :poll_id, :body, presence: true
	
	belongs_to(
	:poll,
	class_name: 'Poll',
	foreign_key: :poll_id,
	primary_key: :id
	)
	
	has_many(
	:answer_choices,
	class_name: 'AnswerChoice',
	foreign_key: :question_id,
	primary_key: :id
	)
	
	has_many(
	:responses,
	through: :answer_choices,
	source: :responses
	)
	
	def results
		self.answer_choices
		    .joins('LEFT OUTER JOIN responses 
				        ON answer_choices.id = responses.answer_choice_id')
				.group('answer_choices.id')
				.select('answer_choices.*, COUNT(responses.id)')
	end
end
