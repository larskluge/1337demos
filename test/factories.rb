Factory.define :demo do |d|
  d.version 11
  d.gamemode "race"
  d.time 14300
  d.data_correct true
  d.status "rendered"
  d.position 1
  d.game "Warsow"

  d.association :map
  d.association :demofile
  d.players { |ps| [ps.association :player] }
end

Factory.define :map do |m|
  m.sequence(:name) { |n| "wdm#{n}" }
end

Factory.define :demofile do |df|
  df.gamemode "race"
  df.file File.new(File.dirname(__FILE__) + "/assets/demofiles/wd11/race_killua-hykon.wd11")
end

Factory.define :player do |p|
  p.after_create do |p|
    nickname = Factory(:nickname, :player => p)
    p.update_attribute(:main_nickname_id, nickname.id)
  end
end

Factory.define :nickname do |nick|
  nick.sequence(:nickname) { |n| "^7soh^8#^9die^1.^9viper#{n}" }
end

