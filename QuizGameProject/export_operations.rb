require 'csv'

class ExportOperations
  def self.export_questions_with_answers(quizzes)
    print "Please enter the file name to export the questions with answers: "
    file_name = gets.chomp.strip

    if file_exists?(file_name)
      file_name = handle_existing_file(file_name)
      return if file_name.nil?
    end

    if file_name.empty?
      puts  "File name can not be empty!Exporting canceled"
      return
    end
    CSV.open(file_name, 'w') do |csv|
      csv << ['Category', 'Question', 'Option1', 'Option2', 'Option3', 'Option4', 'Answer']

      quizzes.each do |quiz|
        quiz.questions.each do |question|
          csv << [quiz.title, question[:text], *question[:options], question[:answer]]
        end
      end
    end

    puts "Questions with answers exported to #{file_name}.csv"
  end

  def self.export_scores_by_category_with_names(scores)
    print "Please enter the file name to export the scores by category with user names: "
    file_name = gets.chomp.strip

    if file_exists?(file_name)
      file_name = handle_existing_file(file_name)
      return if file_name.nil?
    end
    
    if file_name.empty?
      puts "File name can not be empty!Exporting canceled"
      return
    end 

    CSV.open(file_name, 'w') do |csv|
      csv << ['Category', 'Name', 'Score']

      scores.each do |score|
        csv << [score[:category], score[:name], score[:score]]
      end
    end

    puts "Scores by category with user names exported to #{file_name}.csv"
  end

  def self.view_csv_data(file_name)
    if File.exist?(file_name)
      data = CSV.read(file_name)
      category = data[0][0]
      puts "         \nCSV File: #{file_name}"
      puts "=============================="

         data[1..-1].each do |row|
          puts row.join(',')
          puts " "  
         end

      puts "==============================\n"
    else
      puts "File not found. Please enter a valid file name."
    end
  end

  private

  def self.file_exists?(file_name)
    File.exist?(file_name)
  end

  def self.handle_existing_file(file_name)
    count = 3
     print "The file '#{file_name}' already exists. Please enter a different file name: "
     new_file_name = gets.chomp.strip
    loop do
      
      count -= 1
      if file_exists?(new_file_name)
        puts "The file '#{new_file_name}' already exists. Please enter a different file name."
        new_file_name = gets.chomp.strip
      elsif new_file_name.empty?
        puts "Invalid file name. Exporting canceled."
          return
      else
          return new_file_name
      end
      
    end
  end
end