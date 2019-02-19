require 'sqlite3'
require 'singleton'
require_relative 'users'
require_relative 'replies'
class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  def self.all
    data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_author_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = ?
    SQL

      data.map { |datum| Question.new(datum) }
  end

  # update and create method
  # create = create a question
  # update = update the question
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    # SELECT fname, lname FROM users WHERE user_id = id

    data = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        id, fname, lname
      FROM 
        users 
      WHERE 
        id = ?
    SQL
    data.map {|datam| User.new(datam)}
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
end

