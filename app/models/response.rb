# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#

class Response < ActiveRecord::Base
	validates :user_id, :answer_choice_id, presence: true
	validate :respondent_has_not_already_answered_question
	validate :author_cannot_answer_own_poll
	
	belongs_to(
	:respondent,
	class_name: 'User',
	foreign_key: :user_id,
	primary_key: :id
	)
	
	belongs_to(
	:answer_choice,
	class_name: 'AnswerChoice',
	foreign_key: :answer_choice_id,
	primary_key: :id
	)
	
	has_one(
	:question,
	through: :answer_choice,
	source: :question
	)

	
	def sibling_responses
		question.responses.where('? IS NULL OR responses.id != ?', self.id, self.id)
	end
	
	def sibling_responses2
		Response.select('a_responses.* FROM
										responses AS a_responses
										JOIN
										answer_choices AS a_choices
										ON
										a_responses.answer_choice_id = a_choices.id
										JOIN
										questions 
										ON 
										a_choices.question_id = questions.id
										JOIN
										answer_choices AS b_choices
										ON
										questions.id = b_choices.question_id
										JOIN
										responses AS b_responses
										ON
										b_choices.id = b_responses.answer_choice_id
										WHERE
										a_responses.id != 12
										AND
										b_responses.id = 12;')
	end
	
	def respondent_has_not_already_answered_question
		if sibling_responses.where('user_id = ?', self.user_id).exists?
			errors[:previous_response] << "can't exist"
		end
	end
	
	def author_cannot_answer_own_poll
		if question.poll.author_id == self.user_id
			errors[:author] << "can't answer own poll"
		end
	end
end
