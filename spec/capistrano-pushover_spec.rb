require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::Pushover, "loaded into a configuration" do

  before do
    @configuration = Capistrano::Configuration.new
    Capistrano::Pushover.load_into(@configuration)

    @configuration.set :pushover_app_token, 'foo'
    @configuration.set :pushover_user_key, 'bar'
    @configuration.set :application, 'worldrelaxation'
  end

  it "makes sure the configuration variables exits" do 
    @configuration.fetch(:pushover_app_token).should == 'foo'
    @configuration.fetch(:pushover_user_key).should == 'bar'
  end

  it "defines pushover:notify_deploy_started" do
    @configuration.find_task('pushover:notify_deploy_started').should_not == nil
  end
  
  it "defines pushover:notify_deploy_finished" do
    @configuration.find_task('pushover:notify_deploy_finished').should_not == nil
  end
  
  it "defines pushover:configure_for_migrations" do
    @configuration.find_task('pushover:configure_for_migrations').should_not == nil
  end
  
  it "defines pushover:set_user" do
    @configuration.find_task('pushover:set_user').should_not == nil
  end

  it "before pushover:notify_deploy_started performs pushover:set_user" do
    @configuration.should callback('pushover:set_user').before('pushover:notify_deploy_started')
  end

  it "before deploy:migrations performs pushover:configure_for_migrations" do
    @configuration.should callback('pushover:configure_for_migrations').before('deploy:migrations')
  end

  it "before deploy:update_code performs pushover:notify_deploy_started" do
    @configuration.should callback('pushover:notify_deploy_started').before('deploy:update_code')
  end

  it "after deploy performs pushover:notify_deploy_finished" do
    @configuration.should callback('pushover:notify_deploy_finished').after('deploy')
  end

  it "after deploy:migrations performs pushover:notify_deploy_finished" do
    @configuration.should callback('pushover:notify_deploy_finished').after('deploy')
  end

  it "pushover:notify_deploy_started notifing the user deploying and the branch being deployed to production" do
    @configuration.set(:branch, :bar)
    notification = mock('Pushover')
    Rushover::Client.stub(:new).and_return(notification)
    ENV['PUSHOVER_USER'] = 'foobaruser'
    notification.should_receive(:notify).with("bar", "foobaruser is deploying worldrelaxation/bar to production.", {:title=>"worldrelaxation started deploying", :priority=>0})
    @configuration.find_and_execute_task('pushover:notify_deploy_started')
  end


  it "pushover:notify_deploy_finished notifing the user who deployed and the branch that was deployed to production" do
    @configuration.set(:branch, :bar)
    notification = mock('Pushover')
    Rushover::Client.stub(:new).and_return(notification)
    ENV['PUSHOVER_USER'] = 'foobaruser'
    notification.should_receive(:notify).with("bar", "foobaruser finished deploying worldrelaxation/bar to production.", {:title=>"worldrelaxation finished deploying", :priority=>0})
    @configuration.find_and_execute_task('pushover:set_user')
    @configuration.find_and_execute_task('pushover:notify_deploy_finished')
  end

end