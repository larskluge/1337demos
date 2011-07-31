ActiveAdmin.register Demo do
  index do
    column :id
    column :data_correct do |demo|
      check_box_tag 'data_correct', '1', demo.data_correct
    end
    column :status do |demo|
      content_tag 'div', '', class: "statusbox #{demo.status}"
    end

    column :game
    column :gamemode
    column :version

    column :time_title do |demo|
      render_time_title demo
    end
    column :map do |demo|
      render_linked_map demo.map
    end
    column :players do |demo|
      render_linked_players demo.players
    end

    column :created_at
    column :updated_at
    default_actions
  end
end

