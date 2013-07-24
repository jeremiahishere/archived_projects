json.extract! question_answer, :id, :question_id, :player_id, :number_of_votes, :percentage_of_votes, :created_at, :updated_at
json.url question_answer_url(question_answer, format: :json)