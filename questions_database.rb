require 'sqlite3'
require 'singleton'
require_relative 'modelclass.rb'

class QuestionsDB  < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class Question < Model
attr_reader :id , :user_id , :title , :body

    def initialize(options)
        super
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def author
        User.find_by("id", self.user_id).first
    end

    def replies
        Replie.find_by("question_id",self.id)
    end

     def followers
        Question_follow.followers_for_question_id(self.id)
    end


end

class User < Model
attr_reader :id, :fname, :lname
   
    def initialize(options)
        super
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by("user_id",self.id)
    end

    def authored_replies
        Replie.find_by("user_id",self.id)
    end

    def followed_questions
        Question_follow.followed_questions_for_user_id(self.id)
    end


end

class Question_like < Model
attr_reader :id, :question_id, :user_id
   
    def initialize(options)
        super
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

end

class Replie < Model
    attr_reader :id , :question_id , :user_id , :parent_id

    def initialize(options)
        super
        @body = options['body']
        @question_id = options['question_id']
        @user_id = options['user_id']
        @parent_id = options['parent_id']
    end

     def author
        User.find_by("id", self.user_id).first
    end

    def question
        Question.find_by("id",self.question_id)
    end

    def parent_reply
        Replie.find_by("id", self.parent_id)   #what was this a reply to? 
    end

    def child_reply
        Replie.find_by("parent_id", self.id)
    end

end

class Question_follow < Model
    attr_reader :user_id , :question_id
    def initialize(options)
        super
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDB.instance.execute ("
            SELECT *
            FROM users u
            join question_follows qf
            on u.id = qf.user_id
            WHERE qf.question_id = #{question_id}
            ")
            data.map {|datum| User.new(datum)}
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDB.instance.execute ("
            SELECT *
            FROM questions q
            join question_follows qf
            on q.id = qf.question_id
            WHERE qf.user_id = #{user_id}
            ")

            data.map {|datum| Question.new(datum)}
    end


end

qf = Question_follow.followed_questions_for_user_id(3)
qf.each do |question|
    puts "#{question.body}"
end