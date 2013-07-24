class CreateQuestionAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :question_answers do |t|
      t.integer :question_id
      t.integer :player_id
      t.integer :number_of_votes
      t.integer :percentage_of_votes

      t.timestamps
    end
  end
end
