require "sinatra/base"
require "json"
require "ostruct"

class Web < Sinatra::Base

Encoding.default_external = Encoding::UTF_8

  helpers do
    def stop
      ->() {
        pid = Process.pid
        signal = "INT"
        puts "Killing process #{pid} with signal #{signal}"
        Process.kill(signal, pid)
      }
    end
  end

  
  get "/healthz" do
    %{
      ok 
    }
  end



  get "/" do
    node_name = ENV.fetch("RKE_NODE_NAME", "spec.nodeName")
    addr = ENV.fetch("RKE_INSTANCE_ADDR", "status.podIP")
    node_addr = ENV.fetch("RKE_NODE_ADDR", "status.hostIP")
    name = ENV.fetch("RKE_INSTANCE_NAME", "metadata.name")

    %{
      <!DOCTYPE HTML>
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
          <title>Образ #{name}</title>
        </head>
        <body>
          <h1>Привет, я образ #{name}</h1>
          <h2>Мой IP: #{addr}</h2>
          <h2>Запущен на узле: #{node_name}</h2>
          <h2>Адрес моего узла k8s: #{node_addr}</h2>
          <h3>
            <a href="/crash">Crash me</a>
          </h3>
        </body>
      </html>
    }
  end

  get "/env.json" do
    content_type "application/json"
    JSON.pretty_generate(ENV.to_h)
  end

  get "/crash" do
    stop.()
    %{
      <!DOCTYPE HTML>
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
          <title>Образ номер: #{addr}</title>
        </head>
        <body>
          <h2>О нет! Я упал!</h2>
          <h3><a href="/">Проверьте доступно-ли приложение?</a></h3>
        </body>
      </html>
    }
  end
end

run Web.new
