module TodosHelper
  def todos_color(todo)
    return nil if todo.done? || todo.due > 1.day.ago

    todos_color_class(todo.due)
  end

  def todos_color_class(due)
    (1..4).each do |i|
      color = i < 3 ? 'green' : 'red'
      lcolor = (2..3).include?(i) ? '50' : '100'
      dcolor = (2..3).include?(i) ? '950' : '900'

      return "bg-#{color}-#{lcolor} dark:bg-#{color}-#{dcolor}" if ((i + 1).days.ago..i.days.ago).cover?(due)
    end

    'bg-red-200 dark:bg-red-800'
  end
end
