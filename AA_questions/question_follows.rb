require 'sqlite3'
require 'singleton'
require_relative 'questions'

class QuestionFollowsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class QuestionFollow
  def self.all
    data = QuestionFollowsDatabase.instance.execute('SELECT * FROM question_follows')
    data.map { |datum| Reply.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    # people who `likes` the post
    # how to represent boolean? 0 1?
    data = QuestionFollowsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows on questions.id = question_follows.question_id
      JOIN
        users on users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL

    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_user_id(user_id)
    data = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.user_id = ?
    SQL
    
      data.map { |datum| Reply.new(datum) }
  end

  # update and create method
  # create = create a question
  # update = update the question

  def initialize(options)
    @id = options['id']
    @question_id =  options['question_id']
    @user_id = options['user_id']

  end

  def author
    QuestionFollow.find_by_id(@question_id)
  end

  def question
    QuestionFollow.find_by_id(@question_id)
  end

  def parent_reply
    Question_follow.all.first
  end

  def child_Question
    
  end
end

