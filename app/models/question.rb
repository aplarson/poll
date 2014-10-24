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
	primary_key: :id,
	dependent: :destroy
	)
	
	has_many(
	:responses,
	through: :answer_choices,
	source: :responses
	)
	
	def results
		choices = answer_choices
		                   .select('answer_choices.*, COUNT(responses.id) AS count')
 		                   .joins('LEFT OUTER JOIN responses
 				                     ON answer_choices.id = responses.answer_choice_id')
 		                   .group('answer_choices.id')
		result_counts = {}
		choices.each do |choice|
			result_counts[choice.choice] = choice.count
		end
		result_counts
	end
end
