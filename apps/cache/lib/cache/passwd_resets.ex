defmodule Cache.PasswordResets do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: PasswordResetCache)
  end

  def init(state) do
    :ets.new(:passwd_resets, [:set, :public, :named_table])
    
    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:passwd_resets, key) do
        [] -> nil
        [{_key, data, _invalidation}] -> data
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:passwd_resets, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:passwd_resets, object)
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    remove_expired()

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def all do
    :ets.tab2list(:passwd_resets)
  end

  def delete(key) do
    GenServer.cast(PasswordResetCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(PasswordResetCache, {:get, key}, 500)
  end

  def insert(key, value) do
    # {key, value, expiration_time}
    GenServer.cast(PasswordResetCache, {:insert, {key, value, (600 + Joken.current_time) }}) # Valid for next 10 minutes
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 180000) # In 3 minutes
  end

  defp remove_expired do
    # Match spec[{ element, condition, [] }]
    :ets.select_delete(:passwd_resets, [{{:_, :_, :"$1"}, [{:>, Joken.current_time, :"$1"}], [true]}])
  end
end