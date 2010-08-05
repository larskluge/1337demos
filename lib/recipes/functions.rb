# invoke a rake task remotely
#
# Params:
#
# task: the task to execute
# environment: the rails environment to run with (defaults to production)
#
def invoke_rake_task(task, environment = rails_env)
  run "bash -l -c \"cd #{latest_release} && RAILS_ENV=#{environment} rake #{task}\""
end

