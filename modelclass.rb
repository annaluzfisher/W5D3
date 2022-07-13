class Model

    def self.all
        data = QuestionsDB.instance.execute("
            SELECT *
            FROM #{self}s
            "
        )
         data.map {|datum| self.new(datum)}
    end

       def self.find_by(user,idx)
        data = QuestionsDB.instance.execute("
            SELECT *
            FROM #{self}s
            WHERE #{user} = #{idx} "
        )
        data.map {|datum| self.new(datum)}
    end

    def initialize(options)
        @id = options['id']
    end

end
