module Development
  class UsedMemoryReport
    include Singleton

    def initialize
      @reports = []
    end

    def write(label)
      @reports << "used memory: #{label} #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end

    def puts_all
      @reports.each { |report| puts report }
    end
  end
end
