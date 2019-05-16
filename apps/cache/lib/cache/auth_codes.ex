defmodule Cache.AuthCodes do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: CodeCache)
  end

  def init(state) do
    :ets.new(:auth_codes, [:set, :public, :named_table])

    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:auth_codes, key) do
        [] -> nil
        [{_key, code, _invalidation}] -> code
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:auth_codes, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:auth_codes, object)
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    remove_expired()

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def all do
    :ets.tab2list(CodeCache)
  end

  def delete(key) do
    GenServer.cast(CodeCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(CodeCache, {:get, key}, 500)
  end

  def insert(key, value) do
    # {key, value, expiration_time}
    GenServer.cast(CodeCache, {:insert, {key, value, (300 + Joken.current_time) }})
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 180000) # In 3 minutes
  end

  defp remove_expired do
    # Match spec[{ element, condition, [] }]
    :ets.select_delete(:auth_codes, [{{:_, :_, :"$1"}, [{:>, Joken.current_time, :"$1"}], [true]}])
  end
end