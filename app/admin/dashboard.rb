ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    panel "Demos having trouble" do
      ul do
        Demo.where('data_correct IS NULL OR data_correct = 0').map do |demo|
          li link_to("#{demo.id} #{demo.data_correct.nil? ? 'not verified' : 'data incorrect'}", verify_demo_path(demo))
        end
      end
    end
  end
end

