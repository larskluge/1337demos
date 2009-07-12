require 'yaml'

class DemoReaderDefrag
  DM68BIN = '../dm_68/bin/dm_68'

  attr_reader :filename, :version, :mapname, :time, :playernames, :scoreboards, :gamemode, :player, :basegamedir, :gamedir, :valid

  attr_reader :raw


  def initialize(filename)
    @filename = filename


    @version = -1
    @mapname = nil
    @time = nil
    @time_in_msec = nil
    @playernames = []
    @scoreboards = []
    @gamemode = nil
    @player = nil
    @basegamedir = nil
    @gamedir = nil
    @valid = false
    @raw = nil

    self.init()
  end


  def init()
    out = `#{DM68BIN} "#{@filename}"`
    @raw = YAML.load(out)

    raise out unless @raw

    @version = @raw['server_info']['protocol']
    @mapname = @raw['server_info']['mapname']

    # @playernames = []
    # @scoreboards = []
    @basegamedir = @raw['server_info']['gamename']
    @gamedir = @raw['system_info']['fs_game']

    if @raw['server_info']['defrag_vers'].to_i > 0
      @gamemode = @raw['server_info']['df_promode'].to_i.zero? ? 'vq3' : 'cpm'
      # @time = nil
      # @time_in_msec = nil
      @player = @raw['prints'].join('<br />')
    end

    @valid = true
  end


  def time_in_msec
    return @time_in_msec unless @time_in_msec.nil?

    # time str to int
    if @time.kind_of? String
      min, sec, msec = @time.scan(/^([0-9]+):([0-9]+)\.([0-9]+)$/).flatten.map { |x| x.to_i }
      @time_in_msec = msec + sec * 1000 + min * 60 * 1000
    end
  end
end

