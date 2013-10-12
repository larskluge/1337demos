FactoryGirl.define do
  factory :demo do
    version 11
    gamemode "race"
    time 14300
    data_correct true
    status "rendered"
    position 1
    game "Warsow"

    association :map
    association :demofile
    players { |ps| [ps.association(:player)] }
  end

  factory :map do
    sequence(:name) { |n| "wdm#{n}" }
  end

  factory :demofile do
    gamemode "race"
    file File.new(File.dirname(__FILE__) + "/assets/demofiles/wd11/race_killua-hykon.wd11")
  end

  factory :player do
    after(:create) do |p|
      nickname = create(:nickname, :player => p)
      p.main_nickname_id = nickname.id
      p.save!
    end
  end

  factory :nickname do
    sequence(:nickname) { |n| "^7soh^8#^9die^1.^9viper#{n}" }
  end

end

