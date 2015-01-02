use "options"
use "files"

actor Main
  """
  Every point must belong to one and only one set.
  """
  new create(env: Env) =>
    var filename: String = "hps.csv"
    var output: String = "hps.out"
    var space: F64 = 2500
    var time: I16 = 4

    var opt = Options(env)
    opt
      .add("file", "f", "Detections file.", StringArgument)
      .add("output", "o", "Output file.", StringArgument)
      .add("space", "s", "Spacial distance in meters.", F64Argument)
      .add("time", "t", "Time distance in days.", I64Argument)

    for option in opt do
      match option
      | ("file", var arg: String) => filename = arg
      | ("output", var arg: String) => output = arg
      | ("space", var arg: F64) => space = arg.abs()
      | ("time", var arg: I64) => time = arg.abs().i16()
      | ParseError => env.out.print("Unrecognised option.")
      end
    end

    let worker = Worker(output, space, time)

    try
      with file = File.open(filename) do
        // skip the first line
        file.line()

        for line in file.lines() do
          // read cols 2-4
          var offset = line.find(",") + 1
          let x = line.f64(offset)

          offset = line.find(",", offset) + 1
          let y = line.f64(offset)

          offset = line.find(",", offset) + 1
          let day = line.i16(offset)

          var str = line.clone()

          try
            offset = str.find("\r", offset)
            str.truncate(offset.u64())
          else
            try
              offset = str.find("\n", offset)
              str.truncate(offset.u64())
            end
          end

          var point = recover Point(x, y, day, consume str) end
          worker.add(consume point)
        end
      end
    else
      env.out.print("No data set: " + filename)
    end
