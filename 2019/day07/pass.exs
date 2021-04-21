defmodule PassAround do
  import :timer, only: [ sleep: 1 ]

  def pass(controller, name, nextpid \\ nil) do
    receive do
      {:next, nextpid} when is_pid(nextpid) ->
        pass(controller, name, nextpid)
      {value} when is_integer(value) ->
        case value > 0 do
          true ->
            IO.puts("#{name} received #{value}, sending to #{inspect(nextpid)}")
            send(nextpid, {value-1})
            pass(controller, name, nextpid)
          false ->
            IO.puts("#{name} halting")
            send(controller, {:halt, name})
        end
    end
  end

  def start(value \\ 10) do
    me = self()

    pid5 = spawn(PassAround, :pass, [me, "five"])
    pid4 = spawn(PassAround, :pass, [me, "four", pid5])
    pid3 = spawn(PassAround, :pass, [me, "three", pid4])
    pid2 = spawn(PassAround, :pass, [me, "two", pid3])
    pid1 = spawn(PassAround, :pass, [me, "one", pid2])

    # point pid5 to pid1
    send(pid5, {:next, pid1})

    IO.puts("starting in one second")
    sleep(1000)

    # start things off
    send(pid1, {value})

    receiver()
  end

  def receiver() do
    receive do
      {:halt, name} -> IO.puts("#{name} is halted")
      other ->
        IO.puts(inspect(other))
        receiver()
    end
  end
end
