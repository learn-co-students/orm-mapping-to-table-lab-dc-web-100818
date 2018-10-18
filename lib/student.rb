require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id


  # Remember, you can access your database connection anywhere in this class with DB[:conn]
  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

   # creates the students table in the database
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end

  # drops the students table from the database
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  # saves an instance of the Student class to the database and then sets the given students `id` attribute
  def save

    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    # At the end of our save method, we use a SQL query to grab the value of the ID column of the last inserted row, and set that equal to the given song instance's id attribute.
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  # takes in a hash of attributes and uses metaprogramming to create a new student object. Then it uses the #save method to save that student to the database
    returns the new object that it instantiated
  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
end
