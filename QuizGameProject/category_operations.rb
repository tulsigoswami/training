class CategoryOperations
  def self.display_categories(quizzes)
    quizzes.each_with_index do |quiz, index|
      puts "#{index + 1}. #{quiz.title}"
    end
  end

  def self.add_question(quizzes)
    question_text = ''
    puts "\nAvailable Categories:"
    display_categories(quizzes)

    print "\nPlease enter the category number (or enter 'b' to go back to the main menu): "
    category_input = gets.chomp.strip

    return if category_input.downcase == 'b'

    if category_input.match?(/^\d+$/)
      category_number = category_input.to_i

      if (1..quizzes.size).cover?(category_number)
        quiz = quizzes[category_number - 1]
        count=3
        loop do
          print "\nEnter the question: "
          question_text = gets.chomp
          if question_text.empty?
            count-=1
            puts "The question can't be empty"
            if count==0
              puts "No more chances!Moving to the main menu"
            return
            end
          else
            break
          end
        end
        option1 = validate_option('Enter option 1: ')
        option2 = validate_option('Enter option 2: ')
        option3 = validate_option('Enter option 3: ')
        option4 = validate_option('Enter option 4: ')
        answer = validate_answer('Enter the answer (1-4): ')

        new_question = {
          text: question_text,
          options: [option1, option2, option3, option4],
          answer: answer
        }

        quiz.questions << new_question
        save_quiz(quiz) # Save the updated quiz to the corresponding CSV file
        puts "\nQuestion added successfully."
      else
        puts "Invalid category number. Please try again."
        self.add_question(quizzes)
      end
    else
      puts "Invalid input. Please enter a valid category number."
      self.add_question(quizzes)
    end
  end

def self.validate_option(msg)
    option = ''
    loop do
      print msg
      option = gets.chomp
      break unless option.empty?
      puts "Invalid option. Please try again."
    end
    option
  end

  def self.validate_answer(msg)
    answer = nil
    loop do
      print msg
      answer = gets.chomp.to_i
      break if (1..4).cover?(answer)
      puts "Invalid answer. Please enter a value between 1 and 4."
    end
    answer
  end


def self.save_quiz(quiz)
  csv_file = "#{quiz.title.downcase}.csv"

  questions_data = quiz.questions.map do |question|
    [quiz.title, question[:text], *question[:options], question[:answer]]
  end

  CSV.open(csv_file, 'w') do |csv|
    csv << ['Category', 'Question', 'Option1', 'Option2', 'Option3', 'Option4', 'Answer']
    questions_data.each do |data|
      csv << data
    end
  end
end
end
