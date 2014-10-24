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
 *
FROM
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
b_responses.id = 12;