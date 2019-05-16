defmodule Cache.EmailConfirmations do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: EmailConfirmationCache)
  end

  def init(state) do
    :ets.new(:email_confirmations, [:set, :public, :named_table])
    
    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:email_confirmations, key) do
        [] -> nil
        [{_key, uid, _invalidation}] -> uid
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:email_confirmations, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:email_confirmations, object)
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    remove_expired()

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def all do
    :ets.tab2list(:email_confirmations)
  end

  def delete(key) do
    GenServer.cast(EmailConfirmationCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(EmailConfirmationCache, {:get, key}, 500)
  end

  def insert(key, value) do
    # {key, value, expiration_time}
    GenServer.cast(EmailConfirmationCache, {:insert, {key, value, (7200 + Joken.current_time) }})
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 1800000) # In 30 minutes
  end

  defp remove_expired do
    # Match spec[{ element, condition, [] }]
    :ets.select_delete(:email_confirmations, [{{:_, :_, :"$1"}, [{:>, Joken.current_time, :"$1"}], [true]}])
  end
end