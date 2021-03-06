class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute(<<~SQL)
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL
  end

  def self.drop_table
    DB[:conn].execute(<<~SQL)
    DROP TABLE IF EXISTS students;
    SQL
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def save
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

end
