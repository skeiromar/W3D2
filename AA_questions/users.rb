require 'sqlite3'
require 'singleton'
require_relative 'questions'
require_relative 'replies'

class UsersDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  def self.all
    data = UsersDatabase.instance.execute('SELECT * FROM users')
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_name(fname, lname)
    data = UsersDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    data.map { |datum| User.new(datum) }
  end

  # update and create method
  # create = create a User
  # update = update the User

  attr_accessor :fname, :lname, :id

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
    # @is_instructor = options['is_instructor']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    # Use Repy::find_by_user_id
    Reply.find_by_user_id(id)
  end
end

