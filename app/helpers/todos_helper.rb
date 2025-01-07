module TodosHelper
  def todos_color(todo)
    return nil if todo.done? || todo.due > 1.day.ago

    todos_color_class(todo)
  end

  def color_ranges
    {
      'bg-green-100 dark:bg-green-900' => 2.days.ago..1.day.ago,
      'bg-green-50 dark:bg-green-950' => 3.days.ago..2.days.ago,
      'bg-red-50 dark:bg-red-950' => 4.days.ago..3.days.ago,
      'bg-red-100 dark:bg-red-900' => 5.days.ago..4.days.ago
    }
  end

  def todos_color_class(todo)
    color_ranges.each do |color, range|
      return color if range.cover?(todo.due)
    end

    'bg-red-200 dark:bg-red-800'
  end
end
