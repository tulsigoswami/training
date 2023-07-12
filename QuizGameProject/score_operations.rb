require 'csv'

class ScoreOperations
  def self.load_scores(file)
    scores = []

    CSV.foreach(file, headers: true) do |row|
      score = {
        category: row['Category'],
        name: row['Name'],
        score: row['Score'].to_i
      }
      if !score.empty?
      scores << score
      end
    end

    scores
  end

  def self.save_scores(scores, file)
    CSV.open(file, 'w') do |csv|
      csv << ['Category', 'Name', 'Score']

      scores.each do |score|
        csv << [score[:category], score[:name], score[:score]]
      end
    end
  end

  def self.save_score(scores, category, new_score)
  count = 3

  loop do
    print "Please enter your name (or press Enter to skip): "
    name = gets.chomp.strip

    if name.empty?
      count -= 1
      puts "Invalid name. Please try again."

      if count.zero?
        puts "Moving to the main menu..."
        return
      end
    else
      score = {
        category: category,
        name: name,
        score: new_score
      }

      scores << score
      puts "Score saved successfully."
      return
    end
  end
end


  def self.display_scores(scores)
    puts "\nScores:\n"

    scores.each do |score|
      puts "Category: #{score[:category]}, Name: #{score[:name]},Score: #{score[:score]}"
    end
  end

  def self.display_high_scores(scores, quizzes)
    quizzes.each do |quiz|
      highest_scores = scores.select { |score| score[:category] == quiz.title }
      max_score = highest_scores.max_by { |score| score[:score] }
      if max_score
        highest_scores.select! { |score| score[:score] == max_score[:score] }
        puts "#{quiz.title}:"
        highest_scores.each do |score|
          puts "#{score[:name]} - #{score[:score]}"
        end
      end
    end
  end
end
