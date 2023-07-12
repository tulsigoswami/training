require_relative 'quiz'

class QuizLoader
  QUESTION_HEADERS = %w[Category Question Option1 Option2 Option3 Option4 Answer].freeze

  def self.load_quizzes(*files)
    quizzes = []

    files.each do |file|
      quiz = { title: '', questions: [] }
      questions = []

      CSV.foreach(file, headers: true) do |row|
        quiz[:title] = row['Category'] if quiz[:title].empty?

        question = {
          text: row['Question'],
          options: [row['Option1'], row['Option2'], row['Option3'], row['Option4']],
          answer: row['Answer'].to_i
        }

        questions << question
      end

      quiz[:questions] = questions
      quizzes << Quiz.new(quiz[:title], quiz[:questions])
    end

    quizzes
  end
end
