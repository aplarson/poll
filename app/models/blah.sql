SELECT
COUNT(answered_questions)
FROM (
	SELECT
	COUNT(*) AS answered_questions, current_poll.id
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
	users.id = 1
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
);