class Point val
  """
  A single detection.
  """
  let x: F64
  let y: F64
  let day: I16
  let orig: String

  new create(x': F64, y': F64, day': I16, orig': String) =>
    x = x'
    y = y'
    day = day'
    orig = orig'

  fun box apply(that: Point, space2: F64, time: I16): Bool =>
    let dx = that.x - x
    let dy = that.y - y
    let d = (dx * dx) + (dy * dy)

    (d <= space2) and ((that.day - day).abs() <= time)
