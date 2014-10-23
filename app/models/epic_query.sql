SELECT
COUNT(answered_questions)
FROM (
	SELECT
	COUNT(*) AS answered_questions
	FROM
	users
	JOIN
	responses ON users.id = responses.user_id
	JOIN
	answer_choices ON responses.answer_choice_id = answer_choices.id
	JOIN
	questions ON answer_choices.question_id = questions.id
	JOIN
	polls AS current_poll ON questions.poll_id = current_poll.id
	WHERE
	users.id = ?
	GROUP BY
	current_poll.id
	HAVING
	answered_questions = (
		SELECT
		COUNT(*)
		FROM
		polls AS answered_polls
		JOIN
		questions
		ON answered_polls.id = questions.poll_id
		WHERE
		current_poll.id = answered_polls.id
		GROUP BY
		poll_id
	)
)

SELECT
all_responses.*
FROM
answer_choices AS response_answers ON user_responses.answer_choice_id = answer_choices.id
JOIN
questions ON response_answers.question_id = questions.id
JOIN
answer_choices AS question_answers ON questions.id = question_answers.question_id
JOIN
responses AS all_responses ON question_answers.id = all_responses.answer_choice_id
WHERE
(all_responses.user_id != ?userid AND question
