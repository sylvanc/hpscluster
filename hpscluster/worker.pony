use "collections"
use "files"

actor Worker
  var _output: String
  var _space: F64
  var _space2: F64
  var _time: I16
  var _clusters: Array[Cluster] = Array[Cluster]

  new create(output: String, space: F64, time: I16) =>
    _output = output
    _space = space
    _space2 = space * space
    _time = time

  be add(point: Point) =>
    try
      for cluster in _clusters.values() do
        if cluster.add(point, _space, _space2, _time) then
          return None
        end
      end
    end

    _clusters.append(Cluster(point))

  fun ref _final() =>
    try
      with file = File.create(_output) do
        for i in Range(0, _clusters.size()) do
          _clusters(i).write(i, file)
        end
      end
    end
