module StatesHelper
  def date_bound(point, range)
    p = range.send(point)
    (p == 1/0.0 || p == -1/0.0) ? "" : p
  end
end