defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/walletsite/*path" do
    Proxy.forward conn, path, "http://walletsite/"
  end

  match "/fetch/*path" do
    Proxy.forward conn, path, "http://keydownloader/fetch/"
  end

  match "/authorative-bodies/*path" do
    Proxy.forward conn, path, "http://resource/authorative-bodies/"
  end

  match "/wallets/*path" do
    Proxy.forward conn, path, "http://resource/wallets/"
  end

  match "/pubkeys/*path" do
    Proxy.forward conn, path, "http://resource/pubkeys/"

  match "/importer/*path" do
    Proxy.forward conn, path, "http://importer/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
