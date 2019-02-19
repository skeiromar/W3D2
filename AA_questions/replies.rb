require 'sqlite3'
require 'singleton'
require_relative 'questions'

class RepliesDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Reply
  def self.all
    data = RepliesDatabase.instance.execute('SELECT * FROM replies')
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_question_id(question_id)
    data = RepliesDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_user_id(user_id)
    data = RepliesDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?
    SQL
    
      data.map { |datum| Reply.new(datum) }
  end

  # update and create method
  # create = create a question
  # update = update the question
  attr_reader :reply_id, :id
  def initialize(options)
    @id = options['id']
    @question_id =  options['question_id']
    @user_id = options['user_id']
    @reply_id =  options['reply_id']
    @body = options['body']
  end

  def author
    Question.find_by_id(@question_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    # Reply.all.first
    r_id = self.reply_id
    data = RepliesDatabase.instance.execute(<<-SQL, r_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    data.map { |datum| Reply.new(datum) }.first
  end

  def child_replies
    selfid = self.id
    data = RepliesDatabase.instance.execute(<<-SQL, selfid)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL

    data.map { |datum| Reply.new(datum) }
  end
end

