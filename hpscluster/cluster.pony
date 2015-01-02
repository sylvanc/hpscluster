use "files"

class Cluster
  """
  A set of grouped detections.
  """
  var points: Array[Point] = Array[Point]
  var min_x: F64
  var max_x: F64
  var min_y: F64
  var max_y: F64
  var min_day: I16
  var max_day: I16

  new create(point: Point) =>
    points.append(point)
    min_x = point.x
    max_x = point.x
    min_y = point.y
    max_y = point.y
    min_day = point.day
    max_day = point.day

  fun ref add(point: Point, space: F64, space2: F64, time: I16): Bool =>
    if
      (((min_day - point.day).abs() <= time) or
        ((max_day - point.day).abs() <= time)) and
      (((min_x - point.x).abs() <= space) or
        ((max_x - point.x).abs() <= space)) and
      (((min_y - point.y).abs() <= space) or
        ((max_y - point.y).abs() <= space))
    then
      try
        for p in points.values() do
          if p(point, space2, time) then
            min_x = min_x.min(point.x)
            max_x = max_x.max(point.x)
            min_y = min_y.min(point.y)
            max_y = max_y.max(point.y)
            min_day = min_day.min(point.day)
            max_day = max_day.max(point.day)

            points.append(point)
            return true
          end
        end
      end
    end
    false

  fun box write(index: U64, file: File) =>
    var idx: String = index.string()

    try
      for p in points.values() do
        file.write(p.orig)
        file.write(", ")
        file.print(idx)
      end
    end
