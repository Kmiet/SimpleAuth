defmodule Cache.AuthCodes do
  use GenServer

  @code_length 24
  @signing_key_length 64

  @prev_signer "sa_prev"
  @current_signer "sa_current"

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: CodeCache)
  end

  def init(state) do
    :ets.new(:keys, [:set, :public, :named_table])

    schedule_cleanup()
    {:ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply = :ets.lookup(:keys, key)
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

    schedule_cleanup()
    {:noreply, state}
  end

  # Helpers

  def delete(key) do
    GenServer.cast(CodeCache, {:delete, key})
  end

  def get(key) do
    GenServer.call(CodeCache, {:get, key}, 1000)
  end

  def get_signer do
    GenServer.call(CodeCache, {:get, @current_signer}, 1000)
  end

  def get_prev_signer do
    GenServer.call(CodeCache, {:get, @prev_signer}, 1000)
  end

  def insert(key, value) do
    GenServer.cast(CodeCache, {:insert, {key, value}})
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, 86400000) # In 24 hours
  end

  defp update_client_keys do
    
  end

  defp update_provider_keys do
    new_signer = create_hs512_signer()
    current_signer =
      case :ets.lookup(:keys, @current_signer) do
        [] -> new_signer
        [{_key, signer}] -> signer
      end
    :ets.insert(:keys, {@prev_signer, current_signer})
    :ets.insert(:keys, {@current_signer, new_signer})
  end

  defp create_hs512_signer do
    kid = :crypto.strong_rand_bytes(@key_length)
    signing_key = :crypto.strong_rand_bytes(@signing_key_length)
    Joken.Signer.create("HS512", signing_key, %{"kid" => kid})
  end
end