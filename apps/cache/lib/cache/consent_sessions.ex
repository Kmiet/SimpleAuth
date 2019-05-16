defmodule Cache.ConsentSessions do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: ConsentSessionCache)
  end

  def init(state) do
    :ets.new(:consent_sessions, [:set, :public, :named_table])

    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:consent_sessions, key) do
        [] -> nil
        [{_key, consent_session, _invalidation}] -> consent_session
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:consent_sessions, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:consent_sessions, object)
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    remove_expired()

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def all do
    :ets.tab2list(ConsentSessionCache)
  end

  def delete(key) do
    GenServer.cast(ConsentSessionCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(ConsentSessionCache, {:get, key}, 500)
  end

  def insert(key, value) do
    # {key, value, expiration_time}
    GenServer.cast(ConsentSessionCache, {:insert, {key, value, (300 + Joken.current_time) }})
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 300000) # In 5 minutes
  end

  defp remove_expired do
    # Match spec[{ element, condition, [] }]
    :ets.match_delete(ConsentSessionCache, [{ {'_', '_', '$1'}, [{'>', Joken.current_time, '$1'}], [] }])
  end
end