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
	
	def completed_polls
		answered_questions = Poll.joins(
		           'JOIN questions ON questions.poll_id = polls.id
		            JOIN answer_choices ON answer_choices.question_id = questions.id
					      JOIN responses ON answer_choices.id = responses.answer_choice_id
								JOIN users ON responses.user_id = users.id')
								.where('responses.user_id = ?', self.id)
								.group('polls.id').count

		polls_with_questions = Poll.all.includes(:questions)

		fully_answered_polls = []
		polls_with_questions.each do |poll|
			if poll.questions.length == answered_questions[poll.id]
				fully_answered_polls << poll
			end
	  end
		
		fully_answered_polls
	end
	
	def uncompleted_polls
		answered_questions = Poll.joins(
		           'JOIN questions ON questions.poll_id = polls.id
		            JOIN answer_choices ON answer_choices.question_id = questions.id
					      JOIN responses ON answer_choices.id = responses.answer_choice_id
								JOIN users ON responses.user_id = users.id')
								.where('responses.user_id = ?', self.id)
								.group('polls.id').count

		polls_with_questions = Poll.all.includes(:questions)

		unanswered_polls = []
		polls_with_questions.each do |poll|
			if poll.questions.length != answered_questions[poll.id]
				unanswered_polls << poll
			end
	  end
		
		unanswered_polls
	end
end





