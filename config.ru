require "jekyll"
require "yaml"

class JekyllMagic
  def initialize()

    ppid = Process.pid
    cpid = fork do
      Jekyll::Commands::Build.process({watch: true})
    end
    
    fork do
      begin
        loop do
          Process.getpgid(ppid)
          sleep(3)
        end
      rescue
          Process.kill 9, cpid
          sleep(1)
          File.write("tmp/restart.txt", "")
      end
    end

  end

  def call(env)
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('public/index.html', File::RDONLY)
    ]
  end
end

run JekyllMagic.new