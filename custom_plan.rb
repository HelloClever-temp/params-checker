require 'zeus/rails'

class CustomPlan < Zeus::Rails
  class Pry::Pager
    def best_available
      NullPager.new(pry_instance.output)
    end
  end
  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

end

Zeus.plan = CustomPlan.new
