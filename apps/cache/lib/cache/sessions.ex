defmodule Cache.Sessions do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: SessionCache)
  end

  def init(state) do
    :ets.new(:sessions, [:set, :public, :named_table])

    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:sessions, key) do
        [] -> nil
        [{_key, session_data}] -> session_data
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:sessions, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:sessions, object)
    {:noreply, state}
  end

  # Helpers

  def all do
    :ets.tab2list(SessionCache)
  end

  def delete(key) do
    GenServer.cast(SessionCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(SessionCache, {:get, key}, 500)
  end

  def insert(key, value) do
    GenServer.cast(SessionCache, {:insert, {key, value}})
  end
end