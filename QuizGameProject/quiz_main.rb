require_relative 'quiz'
require_relative 'quiz_loader'
require_relative 'category_operations'
require_relative 'score_operations'
require_relative 'export_operations'

class QuizMain
  def initialize
    @quizzes = QuizLoader.load_quizzes('geography.csv', 'history.csv', 'science.csv')
    @scores = ScoreOperations.load_scores('scores.csv')
  end

  def run
    count = 3
    loop do
      puts "=========== Quiz Game ===========\n\n"
      puts "Select an option:"
      puts "1. Select and Take Quiz\n"
      puts "2. View High Scores\n"
      puts "3. Add Questions\n"
      puts "4. View All Scores\n"
      puts "5. Export Data\n"
      puts "6. Exit\n\n"
      
      print "Please enter your choice: "
      choice = gets.chomp.strip

      if choice.empty? || choice.match?(/\D/)
        count -= 1
        puts "Invalid choice. Please try again."

        if count.zero?
          puts "No more chances. Exiting..."
          break
        else
          next
        end
      end
      choice = choice.to_i
      case choice
      when 1
        select_quiz
      when 2
        show_high_scores
      when 3
        CategoryOperations.add_question(@quizzes)
      when 4
        ScoreOperations.display_scores(@scores)
      when 5
        export_data_menu
      when 6
        ScoreOperations.save_scores(@scores, 'scores.csv')
        break
      else
        puts "Invalid choice. Please try again."
      end

      puts "\n"
    end

    puts "Exiting..."
  end

  private

  def select_quiz
    count = 3

    until count.zero?
      puts "\nAvailable Quizzes:\n"
      CategoryOperations.display_categories(@quizzes)

      print "\nPlease enter the quiz number (or enter 'b' to go back to the main menu): "
      quiz_number = gets.chomp.strip

      return if quiz_number.downcase == 'b'

      if quiz_number.empty? || !quiz_number.to_i.between?(1, @quizzes.size)
        count -= 1
        puts "Invalid quiz number. Please try again."

        if count.zero?
          puts "No more chances. Returning to the main menu..."
          break
        end
      else
        quiz_number = quiz_number.to_i
        quiz = @quizzes[quiz_number - 1]
        quiz.play
        ScoreOperations.save_score(@scores, quiz.title, quiz.score[:score])
        break
      end
    end
  end

  def show_high_scores
    puts "\nHigh Scores:"
    ScoreOperations.display_high_scores(@scores, @quizzes)
  end

  def export_data_menu
    count = 3
    loop do
      puts "\nExport Data Menu:"
      puts "1. Export Questions with Answers"
      puts "2. Export Scores by Category with User Names"
      puts "3. View CSV Data"
      puts "4. Back to Main Menu"

      print "\nPlease enter your choice: "
      export_choice = gets.chomp.strip
      
      if export_choice.empty?||export_choice.match?(/\D/)
        count-=1
        puts "Invalid choice, please try again"
        if count==0
          puts "Moving to the main menu"
          break
        else
          next
        end
      else
        export_choice=export_choice.to_i
      end
      case export_choice
      when 1
        ExportOperations.export_questions_with_answers(@quizzes)
      when 2
        ExportOperations.export_scores_by_category_with_names(@scores)
      when 3
        view_csv_data_menu
      when 4
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
  end

  def view_csv_data_menu
    puts "\nCSV Data Menu:"
    puts "1. View Questions with Answers CSV Data"
    puts "2. View Scores by Category with User Names CSV Data"
    puts "3. Back to Export Data Menu"

    print "\nPlease enter your choice: "
    csv_choice = gets.chomp
    if csv_choice.match?(/\D/)
      puts "Invalid choice, please try again"
      view_csv_data_menu
    end
    csv_choice=csv_choice.to_i

    case csv_choice
    when 1
      view_questions_with_answers_data
    when 2
      view_scores_by_category_with_names_data
    when 3
      return
    else
      puts "Invalid choice. Please try again."
      view_csv_data_menu
    end
  end


  def view_questions_with_answers_data
  print "Please enter the file name of the questions with answers CSV: "
  file_name = gets.chomp.strip

  if File.exist?(file_name)
    ExportOperations.view_csv_data(file_name)
  else
    puts "File not found. Please enter a valid file name."
  end
end

def view_scores_by_category_with_names_data
  print "Please enter the file name of the scores by category with user names CSV: "
  file_name = gets.chomp.strip

  if File.exist?(file_name)
    ExportOperations.view_csv_data(file_name)
  else
    puts "File not found. Please enter a valid file name."
  end
end

end

QuizMain.new.run
