defmodule Cache.Keys do
  use GenServer

  @key_length 16
  @signing_key_length 32

  @prev_signer "sa_prev"
  @current_signer "sa_current"

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: KeyCache)
  end

  def init(state) do
    :ets.new(:keys, [:set, :public, :named_table])
    update_provider_keys()
    update_client_keys()

    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = 
      case :ets.lookup(:keys, key) do
        [] -> nil
        [{_key, signer}] -> signer
      end
    {:reply, reply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(:keys, key)
    {:noreply, state}
  end

  def handle_cast({:insert, object}, state) do
    :ets.insert(:keys, object)
    {:noreply, state}
  end

  def handle_info(:cleanup, state) do
    update_provider_keys()
    update_client_keys()

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def delete(key) do
    GenServer.cast(CodeCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(KeyCache, {:get, key}, 500)
  end

  def get_signer do
    {_curr_key, curr_signer} = GenServer.call(KeyCache, {:get, @current_signer}, 300)
    curr_signer
  end

  def insert(key, value) do
    GenServer.cast(CodeCache, {:insert, {key, value}})
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 43200000) # In 12 hours
  end

  defp update_client_keys do
    
  end

  defp update_provider_keys do
    new_signer_spec = create_hs256_signer()
    {new_key, new_signer} = new_signer_spec
    case :ets.lookup(:keys, @current_signer) do
      [] -> 
        :ets.insert(:keys, {@current_signer, new_signer_spec})
        :ets.insert(:keys, {new_key, new_signer})
      [{curr_key, curr_signer}] -> 
        case :ets.lookup(:keys, @prev_signer) do
          [{old_key, _val}] -> :ets.delete(:keys, old_key)
          [] -> nil
        end
        :ets.insert(:keys, {@prev_signer, curr_key})
        :ets.insert(:keys, {@current_signer, new_signer_spec})
        :ets.insert(:keys, {new_key, new_signer})
    end
  end

  defp create_hs256_signer do
    kid = :crypto.strong_rand_bytes(@key_length) |> Base.encode64
    signing_key = :crypto.strong_rand_bytes(@signing_key_length) |> Base.encode64
    {kid, Joken.Signer.create("HS256", signing_key, %{"kid" => kid})}
  end
end