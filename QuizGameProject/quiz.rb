require 'csv'
require 'timeout'

class Quiz
  attr_reader :title, :questions
  f=0
  def initialize(title, questions)
    @title = title
    @questions = questions
    @score = { name: '', score: 0 }
  end

  def play
    puts "Quiz: #{title}\n\n"
    @score[:score] = 0
    questions.each do |question|
      puts question[:text]
      question[:options].each_with_index do |option, index|
        puts "#{index + 1}. #{option}"
      end

      user_answer = get_user_answer_with_timeout
      if user_answer.nil?
        puts "\nTime's up! Moving to the next question."
      else
      check_answer(question, user_answer)
      end
    end

    puts "\nQuiz complete! Your score: #{@score[:score]}/#{questions.size}"
  end

  def score
    @score
  end

  def get_user_answer
    print "Your answer: "
    gets.chomp.to_i
  end

  def get_user_answer_with_timeout
    answer = nil

    begin
      Timeout.timeout(10) do
        answer = get_user_answer
      end
    rescue Timeout::Error
      answer=nil
    end

    answer
  end

  def check_answer(question, user_answer)
    if user_answer == question[:answer]
      puts "Correct!\n\n"
      @score[:score] += 1
    else
        puts "Incorrect"
    end
  end
end
